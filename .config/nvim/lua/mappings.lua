local utils = require 'utils'

-- Wrap function args
utils.nmap('<leader>a', ':ArgWrap<CR>')
-- Grep in current tree
utils.nmap('<leader>c', ':Rg<CR>')
-- Get file path
utils.nmap('<leader>e', ':echo expand("%:p")<CR>')
-- List files in git repo
utils.nmap('<leader>f', ':GFiles --exclude-standard --others --cached<CR>')
-- Next tab
utils.nmap('<leader>n', ':tabn<CR>')
-- Prev tab
utils.nmap('<leader>p', ':tabp<CR>')
-- Open file tree
utils.nmap('<leader>t', ':Lex<CR>')
-- Toggle window
utils.nmap('<leader>w', '<C-W>w')

-- Replace currently selected text
utils.vmap('<leader>r', function()
  vim.cmd [[ noau normal! "vy" ]]
  local selected = vim.fn.getreg('v')
  vim.ui.input({ prompt = 'Replace ' .. selected .. ' with: ' }, function(input)
    if input and input ~= "" then
      vim.cmd('%s/' .. selected .. '/' .. input .. '/g')
    end
  end)
end)

-- Copy to system clipboard in WSL
utils.vmap(
  '<leader>y',
  'y:new ~/.vimbuffer<CR>VGp:x<CR> | :!cat ~/.vimbuffer | clip.exe <CR><CR>'
)
