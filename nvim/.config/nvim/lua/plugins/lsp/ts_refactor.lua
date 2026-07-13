-- Treesitter-locals based goto-definition and scoped rename.
-- Replaces the dropped nvim-treesitter-refactor (navigation.goto_definition +
-- smart_rename), used as the gd/gr provider when no LSP is attached.
local M = {}

local function buf_lang(bufnr)
  local ft = vim.bo[bufnr].filetype
  return vim.treesitter.language.get_lang(ft) or ft
end

-- Collect scope nodes, definitions and references from the `locals` query.
local function get_locals(bufnr, lang)
  local query = vim.treesitter.query.get(lang, 'locals')
  if not query then
    return nil
  end
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  if not ok or not parser then
    return nil
  end
  local tree = parser:parse()[1]
  if not tree then
    return nil
  end
  local root = tree:root()

  local scopes = {} -- node:id() -> true
  local defs = {} -- { node, name }
  local refs = {} -- { node, name }
  for id, node in query:iter_captures(root, bufnr) do
    local cap = query.captures[id]
    if cap == 'local.scope' then
      scopes[node:id()] = true
    elseif cap:find('definition', 1, true) then
      defs[#defs + 1] = { node = node, name = vim.treesitter.get_node_text(node, bufnr) }
    elseif cap:find('reference', 1, true) then
      refs[#refs + 1] = { node = node, name = vim.treesitter.get_node_text(node, bufnr) }
    end
  end
  return { root = root, scopes = scopes, defs = defs, refs = refs }
end

-- Nearest enclosing scope node for a node (nil = global/root scope).
local function enclosing_scope(node, scopes)
  local n = node:parent()
  while n do
    if scopes[n:id()] then
      return n
    end
    n = n:parent()
  end
  return nil
end

-- Resolve the identifier under the cursor to its definition, honoring lexical
-- scope (innermost enclosing definition wins).
local function resolve(bufnr, lang)
  local locals = get_locals(bufnr, lang)
  if not locals then
    return nil
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]
  local cursor_node = locals.root:named_descendant_for_range(row, col, row, col)
  if not cursor_node then
    return nil
  end
  local name = vim.treesitter.get_node_text(cursor_node, bufnr)
  if not name or name == '' or name:find('[%s\n]') then
    return nil
  end

  -- Rank the scopes enclosing the cursor: innermost = 1, root = last.
  local rank = {}
  local order, n = 0, cursor_node
  while n do
    if locals.scopes[n:id()] then
      order = order + 1
      rank[n:id()] = order
    end
    n = n:parent()
  end
  rank['\0root'] = order + 1

  local best, best_rank
  for _, d in ipairs(locals.defs) do
    if d.name == name then
      local s = enclosing_scope(d.node, locals.scopes)
      local r = rank[s and s:id() or '\0root']
      if r and (not best_rank or r < best_rank) then
        best, best_rank = { node = d.node, scope = s }, r
      end
    end
  end
  if not best then
    return nil
  end
  return { name = name, def = best.node, scope = best.scope, locals = locals }
end

-- Jump to the definition of the identifier under the cursor.
---@return boolean handled
function M.goto_definition()
  local bufnr = vim.api.nvim_get_current_buf()
  local r = resolve(bufnr, buf_lang(bufnr))
  if not r then
    return false
  end
  local lr, lc = r.def:start()
  vim.api.nvim_win_set_cursor(0, { lr + 1, lc })
  return true
end

local function within(node, scope)
  if not scope then
    return true -- global scope: whole buffer
  end
  local sr, sc, er, ec = scope:range()
  local nr, nc = node:start()
  local after_start = nr > sr or (nr == sr and nc >= sc)
  local before_end = nr < er or (nr == er and nc <= ec)
  return after_start and before_end
end

-- Rename the identifier under the cursor within its definition's scope.
function M.rename(new_name)
  local bufnr = vim.api.nvim_get_current_buf()
  local r = resolve(bufnr, buf_lang(bufnr))
  if not r then
    vim.notify('No treesitter symbol to rename under cursor', vim.log.levels.INFO)
    return
  end

  if not new_name then
    new_name = vim.fn.input('TS rename "' .. r.name .. '" -> ', r.name)
    if new_name == '' or new_name == r.name then
      return
    end
  end

  -- Collect occurrences, deduped by range: a node can be captured as both a
  -- definition and a reference (e.g. rust), which would double-edit it.
  local occ, seen = {}, {}
  local function add(node)
    if node.name ~= r.name or not within(node.node, r.scope) then
      return
    end
    local sr, sc, er, ec = node.node:range()
    local key = sr .. ':' .. sc .. ':' .. er .. ':' .. ec
    if not seen[key] then
      seen[key] = true
      occ[#occ + 1] = node.node
    end
  end
  for _, d in ipairs(r.locals.defs) do
    add(d)
  end
  for _, ref in ipairs(r.locals.refs) do
    add(ref)
  end

  -- Edit bottom-to-top so earlier ranges stay valid.
  table.sort(occ, function(a, b)
    local ar, ac = a:start()
    local br, bc = b:start()
    if ar ~= br then
      return ar > br
    end
    return ac > bc
  end)
  for _, node in ipairs(occ) do
    local sr, sc, er, ec = node:range()
    vim.api.nvim_buf_set_text(bufnr, sr, sc, er, ec, { new_name })
  end
end

return M
