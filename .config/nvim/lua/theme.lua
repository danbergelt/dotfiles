-- Color scheme
vim.cmd [[ colorscheme eldar ]]

-- Disable status bar
vim.o.laststatus = 0
vim.o.ruler = true

-- Netrw styling
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30

-- Pmenu styling
vim.cmd [[ hi pmenu ctermbg = black ctermfg = white ]]

-- Diagnostic window styling
vim.diagnostic.config {
  underline = true,
  virtual_text = false,
  float = {
    border = "rounded",
    style = "minimal",
    source = "always",
    header = "",
    prefix = ""
  }
}

-- Hover window styling
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)
