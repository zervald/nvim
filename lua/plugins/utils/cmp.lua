return {
  {
    'hrsh7th/nvim-cmp',
    optional = true,
    dependencies = {
      'lukas-reineke/cmp-under-comparator',
    },
    opts = {
      sorting = {
        comparators = function()
          local cmp = require 'cmp'
          return {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            -- require('cmp-under-comparator').under,
            cmp.config.compare.kind,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          }
        end,
      },
    },
  },
  {
    'saghen/blink.cmp',
    optional = true,
    opts = {
      -- experimental signature help support
      -- signature = { enabled = true },
      keymap = {
        preset = 'super-tab',
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<S-CR>'] = {},
      },
      completion = {
        list = {
          selection = {
            -- lazyvim default : false
            preselect = false,
          },
        },
      },
    },
  },
}
