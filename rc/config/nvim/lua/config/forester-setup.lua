vim.filetype.add({ extension = { tree = "forester" } })

--require('nvim-treesitter').setup()

-- https://github.com/kentookura/forester-nvim-config/blob/main/init.lua
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.forester = {
  install_info = {
    url = "https://github.com/kentookura/tree-sitter-forester.git", -- local path or git repo
    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "main", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
  filetype = "forester", -- if filetype does not match the parser name
}

require("nvim-treesitter.configs").setup({
  ensure_installed = { "forester" },
  highlight = {
    enable = true
  }
})

require('forester').setup()
