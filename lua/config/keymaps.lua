-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set
---@diagnostic disable-next-line: unused-local
local unmap = vim.keymap.del
local Snacks = require 'snacks'

--- -- QUICKTERM
---@param cmd? string
---@param wait? boolean
function QuickTerm(cmd, wait)
  local enter = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
  local root = LazyVim.root.get()

  wait = wait or false
  cmd = cmd or ''
  if wait == false then
    cmd = cmd .. enter
  end

  vim.cmd.wa()
  vim.cmd('cd ' .. root)
  Snacks.terminal.open(nil)
  vim.cmd.startinsert()
  vim.fn.feedkeys(cmd)
end

-- cd pwd of buffer with "%%"
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
end, { desc = 'Change pwd to current buffer directory' })

-- Macro
map('n', 'Q', 'q', { desc = 'Record macro' })
map('n', 'q', '')

--Terminal
map({ 'n', 't' }, '<M-#>', function()
  Snacks.terminal.toggle()
end)

-- esc terminal
map('t', '<esc><esc>', '<C-\\><C-n>')

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
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>')
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>')

-- Ctrl - u/d with centering
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')

-- mark with S-M
-- goto mark with M
map('n', 'M', 'm')
map('n', 'm', "'")

-- just run
map('n', '<leader>jr', '<cmd>!just run<cr>')

--change Toggle conceallevel
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 1, name = 'Conceal Level' }):map '<leader>uc'

--tab navigation
--since bufferline disabled
map('n', 'H', '<cmd>tabprevious<cr>')
map('n', 'L', '<cmd>tabnext<cr>')

--neovide
if vim.g.neovide then
  map({ 'n' }, '<C-+>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>')
  map({ 'n' }, '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>')
  map({ 'n' }, '<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>')
end
