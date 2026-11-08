local map = vim.keymap.set
local quickterm = require 'config.quickterm'

map('n', '<leader>rm', function()
  quickterm.open('make ', true)
end, { desc = 'make -' })

map('n', '<leader>rr', function()
  quickterm.open 'make run'
end, { desc = 'make run' })
