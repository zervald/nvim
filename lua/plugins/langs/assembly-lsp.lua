local path = nil
local enter = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
local saveBuffPath = function()
  path = vim.fn.expand("%:p")
end
local rarsCMD = function()
  return { "rars", "rv64", path, enter }
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      asm_lsp = {
        mason = false,
        filetypes = { "asm", "vmasm", "s", "S" },
        keys = {
          {
            "<leader>CC",
            function()
              vim.cmd.wa()
              Snacks.terminal.open()
              vim.cmd("startinsert")
              vim.fn.feedkeys("corrige.py " .. enter)
            end,
            desc = "Run correction in terminal",
          },
          {
            "<leader>CF",
            function()
              vim.cmd.wa()
              saveBuffPath()
              Snacks.terminal.open()
              vim.cmd("startinsert")
              vim.fn.feedkeys(table.concat(rarsCMD(), " "))
            end,
            desc = "Run in floating terminal",
          },
        },
      },
    },
  },
}
