local M = {}

-- Keymapping helper
local map = function(mode, binding, cmd, opts)
  if not opts then
    opts = { silent = true, noremap = true }
  end

  vim.keymap.set(mode, binding, cmd, opts)
end

-- Map key in normal mode
M.nmap = function(binding, cmd, opts)
  map('n', binding, cmd, opts)
end

-- Map key in visual mode
M.vmap = function(binding, cmd, opts)
  map('v', binding, cmd, opts)
end

return M
