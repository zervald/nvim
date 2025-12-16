return {
  'chrisgrieser/nvim-lsp-endhints',
  enabled = false,
  event = 'LspAttach',
  -- opts required, even if empty
  opts = {},
}

--[[
    -- default settings
    require("lsp-endhints").setup({
      icons = {
        type = "󰜁 ",
        parameter = "󰏪 ",
        offspec = " ", -- hint kind not defined in official LSP spec
        unknown = " ", -- hint kind is nil
      },
      label = {
        truncateAtChars = 20,
        padding = 1,
        marginLeft = 0,
        sameKindSeparator = ", ",
      },
      autoEnableHints = true,
    }),
--]]
