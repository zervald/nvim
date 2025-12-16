return {
  {
    'jmbuhr/otter.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {},
  },
  {
    '5ayam5/jupytext.nvim',
    opts = {
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
    },
  },
  {
    'quarto-dev/quarto-nvim',
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'quarto', 'markdown' },
    opts = {
      lspFeatures = {
        -- NOTE: put whatever languages you want here:
        languages = { 'python' },
        chunks = 'all',
        diagnostics = {
          enabled = true,
          triggers = { 'BufWritePost' },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        -- NOTE: setup your own keymaps:
        hover = 'K',
        definition = 'gd',
        rename = '<leader>cr',
        references = 'gr',
        format = '<leader>cf',
      },
      codeRunner = {
        enabled = true,
        default_method = 'molten',
      },
    },
    keys = {
      -- stylua: ignore start
      { "<leader>rc", function() require("quarto.runner").run_cell() end,  mode = "n", ft = {"markdown", "quarto"}, desc = "run cell", silent = true },
      { "<leader>ru", function() require("quarto.runner").run_above() end, mode = "n", ft = {"markdown", "quarto"}, desc = "run cell and above", silent = true },
      { "<leader>ra", function() require("quarto.runner").run_all() end,   mode = "n", ft = {"markdown", "quarto"}, desc = "run all cells", silent = true },
      { "<leader>rl", function() require("quarto.runner").run_line() end,  mode = "n", ft = {"markdown", "quarto"}, desc = "run line", silent = true },
      { "<leader>r",  function() require("quarto.runner").run_range() end, mode = "v", ft = {"markdown", "quarto"}, desc = "run visual range", silent = true },
      -- { "n", "<localleader>rA", function() runner.run_all(true) end, { desc = "run all cells of all languages", silent = true } },
      -- stylua: ignore end
    },
  },
  {
    'benlubas/molten-nvim',
    -- version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    dependencies = { 'folke/snacks.nvim' },
    ft = { 'markdown', 'quarto' },
    build = ':UpdateRemotePlugins',
    keys = {
      -- stylua: ignore start
      -- { "n", "<space>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true } },
      -- { "n", "<space>ro", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator", silent = true } },
      -- { "n", "<space>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" } },
      -- { "v", "<space>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "execute visual selection", silent = true } },
      { "<leader>ri", ":MoltenInterrupt<CR>",             mode = "n", desc = "interrupt runner", silent = true },
      { "<leader>mm", "zt :noautocmd MoltenEnterOutput<CR>", mode = "n", desc = "open output window", silent = true  },
      { "<leader>mq", ":MoltenHideOutput<CR>",            mode = "n", desc = "close output window", silent = true  },
      { "<leader>md", ":MoltenDelete<CR>",                mode = "n", desc = "delete Molten cell", silent = true  },
      { "<leader>ms", ":MoltenImagePopup<CR>",            mode = "n", desc = "Show images in exteral viewer", silent = true  },
      { "<leader>mi", function()
        local venv = os.getenv("DIRENV_DIR") or os.getenv("CONDA_PREFIX") or os.getenv("VIRTUAL_ENV")
        if venv ~= nil then
          -- in the form of /home/user/.virtualenvs/VENV_NAME
          venv = string.match(venv, "/.+/(.+)")
          print(venv)
          vim.cmd(("MoltenInit %s"):format(venv))
        else
          vim.cmd("MoltenInit")
        end
      end,
        mode = "n", ft = {"markdown", "quarto"},desc = "Initialize the plugin", silent = true  },
      -- stylua: ignore end
    },
    init = function()
      -- Output window height (MoltenEnterOutput)
      -- vim.g.molten_output_win_max_height = 30
      -- I find auto open annoying, keep in mind setting this option will require setting
      -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
      vim.g.molten_auto_open_output = true

      -- When the window can't display the entire contents of the output buffer,
      -- shows the number of extra lines in the window footer (requires nvim 10.0+ and a window border)
      vim.g.molten_output_show_more = true

      -- this guide will be using image.nvim
      -- Don't forget to setup and install the plugin if you want to view image outputs
      vim.g.molten_image_provider = 'snacks.nvim'

      -- optional, I like wrapping. works for virt text and the output window
      vim.g.molten_wrap_output = false

      -- Output as virtual text. Allows outputs to always be shown, works with images, but can
      -- be buggy with longer images
      vim.g.molten_virt_text_output = false

      -- this will make it so the output shows up below the \`\`\` cell delimiter
      vim.g.molten_virt_lines_off_by_1 = true

      -- When true, uses different highlights for output border
      -- depending on the state of the cell (running, done, error). see highlights
      vim.g.molten_use_border_highlights = true

      vim.g.molten_enter_output_behavior = 'open_and_enter'

      -- stylua: ignore start
      -- vim.keymap.set("n", "<leader>ro", ":MoltenEvaluateOperator<CR>", { silent = true, desc = "evaluate operator" })
      -- vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
      -- vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" })
      -- vim.keymap.set("n", "<leader>ri", ":MoltenInterrupt<CR>", { silent = true, desc = "interrupt" })
      -- vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "evaluate visual selection" })
      -- vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
      -- vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { silent = true, desc = "molten delete cell" })
      -- vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
      -- vim.keymap.set("n", "<leader>ms", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "show/enter output" })

      -- if you work with html outputs:
      -- vim.keymap.set( "n", "<localleader>mx", ":MoltenOpenInBrowser<CR>", { desc = "open output in browser", silent = true })
      -- stylua: ignore end
    end,
  },
  -- TODO: Treesitter setup https://github.com/benlubas/molten-nvim/blob/main/docs/Notebook-Setup.md#treesitter-text-objects
}
