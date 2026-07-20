return {
  'neovim/nvim-lspconfig',
  opts = {
    servers = {
      ocamllsp = {
        mason = require('nixCatsUtils').lazyAdd(true, false),
      },
    },
  },
}
