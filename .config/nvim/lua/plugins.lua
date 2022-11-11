local needs_bootstrap = function()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  -- If `packer` isn't installed, we are probably on a fresh machine and need to fetch dependencies
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[ packadd packer.nvim ]]
    return true
  end
  return false
end

return require('packer').startup(function(use)
  -- Package manager and LSP
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/plenary.nvim'
  use 'b0o/schemastore.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'

  -- Autocomplete
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'

  -- Theme
  use 'danbergelt/vim-eldar'

  -- Function argument wrapping
  use 'FooSoft/vim-argwrap'

  -- Fuzzy finder
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- Pair ([], {}, <>, etc) helpers
  use 'tpope/vim-surround'
  use 'Raimondi/delimitmate'

  -- Comment shortcuts
  use 'tpope/vim-commentary'

  -- Git shortcuts
  use 'tpope/vim-fugitive'

  -- Syntax highlighting
  use 'sheerun/vim-polyglot'

  if needs_bootstrap() then
    require('packer').sync()
  end
end)
