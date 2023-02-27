-- from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/snips/ft/rust.lua
local ls = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt
local snippet_collection = require('luasnip.session.snippet_collection')

local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node

local shared = require('plugins.snips.utils')
local same = shared.same

snippet_collection.clear_snippets('rust')
ls.add_snippets('rust', {
  s(
    'tmain',
    fmt(
      [[
#[tokio::main]
async fn main() -> anyhow::Result<()> {{
  Ok(())
}}]],
      {}
    )
  ),

  s(
    'main',
    fmt(
      [[
    fn main() {{
    }}
    ]],
      {}
    )
  ),
  s(
    'modtest',
    fmt(
      [[
      #[cfg(test)]
      mod test {{
          use super::*;
          {}
      }}
    ]],
      i(0)
    )
  ),
  s(
    { trig = 'test' },
    fmt(
      [[
  #[test]
  fn {}(){}{{
    {}
  }}
  ]],
      {
        i(1, 'testname'),
        c(2, {
          t(''),
          t(' -> Result<()> '),
        }),
        i(0),
      }
    )
  ),
  s('eq', fmt('assert_eq!({}, {});{}', { i(1), i(2), i(0) })),
  s('enum', {
    t({ '#[derive(Debug, PartialEq)]', 'enum ' }),
    i(1, 'Name'),
    t({ ' {', '  ' }),
    i(0),
    t({ '', '}' }),
  }),

  s('struct', {
    t({ '#[derive(Debug, PartialEq)]', 'struct ' }),
    i(1, 'Name'),
    t({ ' {', '    ' }),
    i(0),
    t({ '', '}' }),
  }),

  s('pd', fmt([[println!("{}: {{:?}}", {});]], { same(1), i(1) })),
})
