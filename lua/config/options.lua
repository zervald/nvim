-- === Variables ===
-- Autoformat on save setting
local set_autoformat = function(pattern, bool_val)
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = pattern,
    callback = function()
      vim.b.autoformat = bool_val
    end,
  })
end

local on_wsl = vim.fn.has 'wsl' == true
local on_windows = vim.fn.has 'win32' == true or vim.fn.has 'win64' == true

-- === Options ===
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/vim.options.lua
-- Add any additional vim.options here

vim.o.winborder = 'rounded'

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
-- vim.opt.tabstop = 4 -- Number of spaces tabs count for
-- vim.opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
-- vim.opt.shiftwidth = 4 --number of spaces used for each step of (auto)indent

vim.opt.conceallevel = 1
vim.opt.breakindent = true
vim.opt.colorcolumn = '100'

-- vim.g.clipboard = 'unnamed'

-- vim.g.maplocalleader = ","
-- vim.g.mapleader = "<space>"
-- vim.g.mapleader = " "

vim.opt.autochdir = false

vim.opt.spelllang = 'fr'

-- vim.g.root_spec = { '.git', { 'lsp', 'lua' }, 'cwd' }
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- Windows
if on_windows then
  -- pwsh on windows, otherwise defaults to cmd
  if vim.fn.executable 'pwsh' == true then
    vim.g.shell = 'pwsh'
  end

  set_autoformat({ 'cs' }, false)
  set_autoformat({ 'cpp' }, false)
  set_autoformat({ 'py' }, false)
end

-- WSL
if on_wsl then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.8
end
