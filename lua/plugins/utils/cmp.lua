local cmp = require 'cmp'
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'lukas-reineke/cmp-under-comparator',
  },
  opts = {
    sorting = {
      comparators = {
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
      },
    },
  },
}
