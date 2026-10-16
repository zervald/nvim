return {
  'folke/snacks.nvim',
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    styles = {
      ['float'] = {
        width = 0,
        height = 0,
      },
    },
    -- picker = {
    --   layout = {
    --     config = function(layout)
    --       layout.layout.height = 0
    --       layout.layout.width = 0
    --     end,
    --   },
    -- },
    zen = {
      -- You can add any `Snacks.toggle` id here.
      -- Toggle state is restored when the window is closed.
      -- Toggle config options are NOT merged.
      win = {
        backdrop = {
          transparent = false,
          blend = 90,
        },
      },
      ---@type table<string, boolean>
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
        -- diagnostics = false,
        -- inlay_hints = false,
      },
      show = {
        statusline = true,
      },
    },
  },
}
