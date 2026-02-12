-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/vim.options.lua
-- Add any additional vim.options here

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
-- vim.opt.tabstop = 4 -- Number of spaces tabs count for
-- vim.opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
-- vim.opt.shiftwidth = 4 --number of spaces used for each step of (auto)indent

vim.opt.conceallevel = 1
vim.opt.breakindent = true

vim.opt.clipboard = 'unnamed'

-- vim.g.maplocalleader = ","
-- vim.g.mapleader = "<space>"
-- vim.g.mapleader = " "

vim.opt.autochdir = false

vim.opt.spelllang = 'fr'

-- vim.g.root_spec = { '.git', { 'lsp', 'lua' }, 'cwd' }
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- autoformat on save
-- Autoformat setting
local set_autoformat = function(pattern, bool_val)
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = pattern,
    callback = function()
      vim.b.autoformat = bool_val
    end,
  })
end

-- on windows
if vim.fn.has 'wsl' then
  vim.o.shell = 'fish'
elseif vim.fn.has 'win32' or 'win64' then
  vim.o.shell = 'powershell.exe'
  set_autoformat({ 'cs' }, false)
end

if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.9
end
