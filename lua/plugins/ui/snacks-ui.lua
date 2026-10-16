return {
  'folke/snacks.nvim',
  ---@type Snacks.Config
  opts = {
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
} ---@class snacks.zen.Config
