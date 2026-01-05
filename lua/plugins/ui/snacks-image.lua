return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    ---@class snacks.image.Config
    image = {
      enabled = true,
      resolve = function(path, src)
        local api = require 'obsidian.api'
        if api.path_is_note(path) then
          return api.resolve_attachment_path(src)
        end
      end,
      doc = {
        enabled = true,
        -- inline = false, -- default: true
        max_width = 120,
        max_height = 15,
      },
    },
  },
}
