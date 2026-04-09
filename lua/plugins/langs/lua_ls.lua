return {
  'neovim/nvim-lspconfig',
  opts = {
    servers = {
      lua_ls = {
        mason = require('nixCatsUtils').lazyAdd(true, false),
      },
    },
  },
}
