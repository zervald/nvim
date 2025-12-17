-- NOTE: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup {
  non_nix_value = true,
}

-- NOTE: You might want to move the lazy-lock.json file
local lazyOptions = {
  lockfile = require('nixCats').configDir .. '/lazy-lock.json',
}

vim.g.lazyvim_json = require('nixCats').configDir .. '/lazyvim.json'

-- NOTE: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
  { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },
  -- disable mason.nvim while using nix
  -- precompiled binaries do not agree with nixos, and we can just make nix install this stuff for us.
  { 'mason-org/mason-lspconfig.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },
  { 'mason-org/mason.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },
  { 'jay-babu/mason-nvim-dap.nvim', enabled = require('nixCatsUtils').lazyAdd(true, false) },
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   branch = 'main',
  --   event = { 'LazyFile', 'VeryLazy' },
  --   build = require('nixCatsUtils').lazyAdd ':TSUpdate',
  --   opts_extend = require('nixCatsUtils').lazyAdd({ 'ensure_installed' }, false),
  --   opts = {
  --     -- nix already ensured they were installed, and we would need to change the parser_install_dir if we wanted to use it instead.
  --     -- so we just disable install and do it via nix.
  --     indent = { enable = true },
  --     highlight = { enable = true },
  --     folds = { enable = true },
  --     ensure_installed = require('nixCatsUtils').lazyAdd { 'all' },
  --     auto_install = require('nixCatsUtils').lazyAdd(true, false),
  --   },
  -- },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
      },
    },
  },
  -- import/override with your plugins
  { import = 'plugins' },
}, lazyOptions)
