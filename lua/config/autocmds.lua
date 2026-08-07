-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local Snacks = require 'snacks'
local LazyVim = require 'lazyvim'

vim.cmd 'highlight ColorColumn ctermbg=0 guibg=#222434'

-- -- QUICKTERM launch a snacks terminal with a provided cmd
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
