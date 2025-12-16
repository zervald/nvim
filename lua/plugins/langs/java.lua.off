local enter = vim.api.nvim_replace_termcodes("<CR>", true, true, true)

return {
  "nvim-java/nvim-java",
  lazy = true,
  config = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          jdtls = {
            handlers = {
              ["$/progress"] = function(_) end,
            },
            format = {
              settings = {
                enabled = true,
              },
            },
          },
        },
        setup = {
          jdtls = function()
            require("java").setup({
              -- Your custom nvim-java configuration goes here
              jdk = { auto_install = false },
              -- java = { home = "/usr/lib/jvm/java/bin/java", },
              spring_boot_tools = {
                enable = true,
              },
            })
          end,
        },
        inlay_hints = {
          exclude = { "jdtls" },
        },
      },
    },
    {
      "folke/noice.nvim",
      opts = {
        lsp = {
          hover = {
            silent = true,
          },
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = { "jdtls" },
      },
    },
    {
      "stevearc/conform.nvim",
      opts = {
        -- formatters = { java = { -- prepend_args = { "-i", "2" }, }, },
        formatters_by_ft = {
          java = { "google-java-format" },
        },
      },
    },
  },
  keys = {
    {
      "<leader>rM",
      function()
        vim.cmd.wa()
        Snacks.terminal.open("exec fish", { cwd = LazyVim.root.git() })
        vim.cmd("startinsert")
        vim.fn.feedkeys("mvn ")
      end,
      desc = "Maven floating terminal",
      ft = "java",
    },
    {
      "<leader>rm",
      function()
        vim.cmd.wa()
        Snacks.terminal.open(nil, { cwd = LazyVim.root.git(), win = { relative = "right" } })
        vim.cmd("startinsert")
        vim.fn.feedkeys("mvn clean package" .. enter)
      end,
      desc = "Compile with Maven (mvn clean package)",
      ft = "java",
    },
    {
      "<leader>rr",
      function()
        require("java").runner.built_in.run_app({})
      end,
      desc = "Nvim-Java runner",
      ft = "java",
    },
  },
}
-- keys = { { "<leader>cjc", function() vim.cmd.wa() vim.cmd("terminal " .. compileCMD .. "; ") vim.cmd("startinsert") end, desc = "Compile Project", }, { "<leader>cjr", ":term java -cp ./bin Main", desc = "Run in terminal", }, { "<leader>cjq", function() vim.cmd.wa() vim.cmd("terminal " .. compileCMD .. "; " .. runCMD) vim.cmd("startinsert") end, desc = "Quick build and run (Insert mode)", }, -- { "<leader>cjf", function() vim.cmd.wa() LazyVim.terminal({ "bash ", "-c ", runCMD }) end, desc = "Run in floating terminal", }, },

-- Maven cmd tool
--     "eatgrass/maven.nvim", cmd = { "Maven", "MavenExec" }, dependencies = "nvim-lua/plenary.nvim", config = function() require("maven").setup({ executable = "./mvnw", }) end,
