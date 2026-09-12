return {
  'folke/trouble.nvim',
  optional = true,
  ---@class trouble.Mode: trouble.Config,trouble.Section.spec
  ---@field desc? string
  ---@field sections? string[]

  ---@class trouble.Config
  ---@field mode? string
  ---@field config? fun(opts:trouble.Config)
  ---@field formatters? table<string,trouble.Formatter> custom formatters
  ---@field filters? table<string, trouble.FilterFn> custom filters
  ---@field sorters? table<string, trouble.SorterFn> custom sorters
  opts = {
    ---@type table<string, trouble.Mode>
    modes = {
      -- more advanced example that extends the lsp_document_symbols
      symbols = {
        win = { position = 'left' },
      },
    },
  },
}
