local function get_progress()
  return '%6o %3l:%-2v'
end

require('lualine').setup({
  sections = {
    lualine_c = {
      {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
      },
    },
    lualine_z = { get_progress },
  },
})
