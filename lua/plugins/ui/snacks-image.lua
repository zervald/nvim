return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    ---@class snacks.image.Config
    image = {
      enabled = true,
      doc = {
        enabled = true,
        -- inline = false, -- default: true
        max_width = 120,
        max_height = 15,
      },
    },
  },
}
