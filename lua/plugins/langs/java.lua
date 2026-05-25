return {
  {
    'neovim/nvim-lspconfig',
    optional = true,
    opts = {
      servers = {
        jdtls = {
          handlers = {
            ['$/progress'] = function(_) end,
          },
          format = {
            settings = {
              enabled = true,
            },
          },
        },
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      optional = true,
      opts = {
        ensure_installed = { 'java' },
      },
    },
    {
      'stevearc/conform.nvim',
      optional = true,
      opts = {
        -- formatters = { java = { -- prepend_args = { "-i", "2" }, }, },
        formatters_by_ft = {
          java = { 'google-java-format' },
        },
      },
    },
  },
}
