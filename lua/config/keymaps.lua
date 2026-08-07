-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Snacks = require 'snacks'
local LazyVim = require 'lazyvim'
local map = vim.keymap.set
---@diagnostic disable-next-line: unused-local
local unmap = vim.keymap.del

-- Terminal
map({ 'n', 't' }, '<M-#>', function()
  Snacks.terminal.toggle()
end)

-- leave TERMINAL mode (to NORMAL mode)
-- map('t', '<esc><esc>', '<C-\\><C-n>')

-- abreviation: %% -> buffer parent dir
local fn = vim.fn
map('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand '%:h' .. '/'
  else
    return '%%'
  end
end, { expr = true })

-- leader p change pwd
map('n', '<leader>p', function()
  vim.cmd 'cd %:h/'
end, { desc = 'Set pwd buffer parent directory' })

-- Macro
map('n', 'Q', 'q', { desc = 'Record macro' })
map('n', 'q', '')

-- Spelling lang
unmap('n', '<leader>ul')
map('n', '<leader>ul', function()
  local lang = vim.o.spelllang
  if lang == 'en' then
    vim.o.spelllang = 'fr'
  else
    vim.o.spelllang = 'en'
  end
end, { desc = 'Change spelling language' })

-- switch Trouble diagnostic
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Diagnostics (Buffer)' })
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (All)' })

-- Ctrl - u/d with centering
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')

-- H, L cycle tabs
map('n', 'H', '<cmd>tabprevious<cr>')
map('n', 'L', '<cmd>tabnext<cr>')

-- mark with S-M
-- goto mark with M
map('n', 'M', 'm')
map('n', 'm', "'")

--change Toggle conceallevel
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 1, name = 'Conceal Level' }):map '<leader>uc'

--neovide
if vim.g.neovide then
  map({ 'n' }, '<C-+>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>')
  map({ 'n' }, '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>')
  map({ 'n' }, '<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>')
end

-- from diagnostic to quickfix list
vim.keymap.set('n', '<leader>xd', function()
  local diagnostics = vim.diagnostic.get(0)
  local qflist = {}
  for _, diagnostic in ipairs(diagnostics) do
    table.insert(qflist, {
      bufnr = diagnostic.bufnr,
      lnum = diagnostic.lnum + 1,
      col = diagnostic.col + 1,
      text = diagnostic.message,
      type = diagnostic.severity == vim.diagnostic.severity.ERROR and 'E' or 'W',
    })
  end
  vim.fn.setqflist(qflist)
end, { desc = 'Send Diagnostics To QF List' })

-- clear qflist
vim.keymap.set('n', '<leader>xc', function()
  vim.fn.setqflist {}
end, { desc = 'Clear quickfix list' })
