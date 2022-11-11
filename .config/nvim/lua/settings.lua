local utils = require 'utils'

-- Set leader to space
vim.g.mapleader = " "

-- Dictionary (access with <C-x><C-k>)
vim.o.dictionary = '/usr/share/dict/words'

-- TODO: Thesaurus

-- Line number config
vim.o.number = true
vim.o.relativenumber = true

-- Disable modelines
vim.o.modelines = 0

-- Set scrolloff padding to 5 lines
vim.o.scrolloff = 5

-- Set popup menu behavior
vim.o.completeopt = "menuone,noselect,noinsert"

-- Indentation settings
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Improve backspace functionality
vim.o.backspace = "indent,eol,start"

-- Search options
vim.o.incsearch = true
vim.o.ignorecase = true
-- Unset search highlight by hitting return
utils.nmap('<CR>', ':noh<CR><CR>')

-- Buffers read live changes
vim.o.autoread = true

-- Indentation overrides
vim.cmd [[
  autocmd filetype ocaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd filetype scheme setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd filetype lua setlocal tabstop=2 softtabstop=2 shiftwidth=2
]]
