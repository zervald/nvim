return {
  {
    "mrcjkb/rustaceanvim",
    keys = {
      {
        "<leader>rr",
        "<cmd>RustLsp runnables<cr>",
        desc = "RustLsp runnables",
        ft = "rust",
      },
    },
  },
  {
    "cordx56/rustowl",
    enabled = false,
    version = "*", -- Latest stable version
    build = "cargo binstall rustowl",
    lazy = false, -- This plugin is already lazy
    opts = {
      client = {
        on_attach = function(_, buffer)
          vim.keymap.set("n", "<leader>o", function()
            require("rustowl").toggle(buffer)
          end, { buffer = buffer, desc = "Toggle RustOwl" })
        end,
      },
    },
  },
}
