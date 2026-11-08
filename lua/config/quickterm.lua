local Snacks = require 'snacks'
local LazyVim = require 'lazyvim'

local M = {}

---QUICKTERM: launch a snacks terminal in the project root with a provided cmd
---@param cmd? string
---@param wait? boolean when true, the command is typed but not executed (no <CR>)
function M.open(cmd, wait)
  local enter = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
  local root = LazyVim.root.get()

  wait = wait or false
  cmd = cmd or ''
  if wait == false then
    cmd = cmd .. enter
  end

  vim.cmd.wa()
  vim.cmd.cd { args = { root } }
  Snacks.terminal.open(nil)
  vim.cmd.startinsert()
  vim.fn.feedkeys(cmd)
end

return M
