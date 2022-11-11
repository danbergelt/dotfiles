local lsp = require 'lspconfig'
local cmp = require 'cmp'
local cmp_lsp = require 'cmp_nvim_lsp'
local null_ls = require 'null-ls'

local utils = require 'utils'

-- Diagnostics
utils.nmap('<C-h>', vim.diagnostic.open_float)

-- LSP
local on_attach = function(_, bufnr)
  -- If autocomplete is open, perform an action
  local cmp_do = function(callback)
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        callback()
      else
        fallback()
      end
    end, { 'i', 's' })
  end

  -- Completion
  cmp.setup {
    sources = cmp.config.sources {
      -- Language server
      { name = 'nvim_lsp' },
      -- Current buffer
      { name = "buffer" },
      -- Filesystem
      { name = "path" },
    },
    mapping = {
      ['<C-q>'] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close()
      },
      ["<Tab>"] = cmp_do(cmp.select_next_item),
      ["<S-Tab>"] = cmp_do(cmp.select_prev_item),
    },
    window = {
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      }
    },
  }

  local lsp_opts = {
    noremap = true,
    silent = true,
    buffer = bufnr
  }

  -- Hover
  utils.nmap('<C-i>', vim.lsp.buf.hover, lsp_opts)

  -- Go to definition
  utils.nmap('<C-d>', vim.lsp.buf.definition, lsp_opts)

  -- Disable ghost text
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = false }
  )
end


-- Python
lsp.pyright.setup {
  on_attach = on_attach,
  capabilities = cmp_lsp.default_capabilities()
}

-- TS/JS
lsp.tsserver.setup {
  on_attach = on_attach,
  capabilities = cmp_lsp.default_capabilities()
}

-- JSON
lsp.jsonls.setup {
  on_attach = on_attach,
  capabilities = cmp_lsp.default_capabilities(),
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true }
    }
  }
}

-- CSS
lsp.cssls.setup {
  on_attach = on_attach,
  capabilities = cmp_lsp.default_capabilities()
}

-- HTML
lsp.html.setup {
  on_attach = on_attach,
  capabilities = cmp_lsp.default_capabilities()
}

-- Lua
lsp.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = cmp_lsp.default_capabilities(),
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

local on_null_ls_attach = function(client, buffer)
  -- Format on save
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds {
      group = augroup,
      buffer = buffer
    }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = buffer,
      callback = function()
        vim.lsp.buf.format()
      end
    })
  end
end

-- Additional linting + formatting
null_ls.setup {
  on_attach = on_null_ls_attach,
  sources = {
    -- Formatting
    null_ls.builtins.formatting.trim_newlines,
    null_ls.builtins.formatting.trim_whitespace,

    -- Diagnostics
    null_ls.builtins.diagnostics.eslint, -- TS/JS
    null_ls.builtins.diagnostics.flake8, -- Python
    null_ls.builtins.diagnostics.hadolint, -- Docker
    null_ls.builtins.diagnostics.shellcheck, -- Shell
    null_ls.builtins.diagnostics.proselint, -- Writing
    null_ls.builtins.diagnostics.sqlfluff.with { -- SQL
      -- I mostly use PG
      extra_args = { "--dialect", "postgres" }
    }
  }
}
