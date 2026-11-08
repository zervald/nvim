-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd 'highlight ColorColumn ctermbg=0 guibg=#222434'

vim.api.nvim_create_augroup('formatting', { clear = false })

-- Keep final EOL consistent on save (fixeol: restore a missing EOL at EOF)
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
  group = 'formatting',
  pattern = '*',
  command = 'setl fixeol',
})

-- ionodes cmd
vim.api.nvim_create_user_command('Ionodes', function(opts)
  if opts.args == 'cpp' or opts.args == 'import' then
    require('config.ionodes')[opts.args]()
  else
    vim.notify('Usage: :Ionodes {cpp|import}', vim.log.levels.ERROR)
  end
end, {
  nargs = 1,
  complete = function(arg)
    return vim.tbl_filter(function(command)
      return vim.startswith(command, arg)
    end, { 'cpp', 'import' })
  end,
  desc = 'Ionodes project tools',
})

-- User commands must start uppercase; expand the lowercase spelling only in command position.
-- vim.cmd [[cnoreabbrev <expr> ionodes getcmdtype() ==# ':' && getcmdline() =~# '^ionodes$' ? 'Ionodes' : 'ionodes']]
