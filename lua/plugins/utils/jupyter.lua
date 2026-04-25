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
    ft = { 'quarto', 'markdown' },
    build = ':UpdateRemotePlugins',
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

      -- must
      vim.keymap.set('n', '<leader>me', ':MoltenEvaluateOperator<CR>', { desc = 'evaluate operator', silent = true })
      vim.keymap.set('n', '<leader>mm', 'zt :noautocmd MoltenEnterOutput<CR>', { desc = 'open output window', silent = true })
      vim.keymap.set('v', '<leader>me', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'execute visual selection', silent = true })
      vim.keymap.set('n', '<leader>mc', ':MoltenInterrupt<CR>', { desc = 'interrupt runner', silent = true })
      vim.keymap.set('n', '<leader>mr', ':MoltenReevaluateCell<CR>', { desc = 're-eval cell', silent = true })
      vim.keymap.set('n', '<leader>mq', ':MoltenHideOutput<CR>', { desc = 'close output window', silent = true })
      vim.keymap.set('n', '<leader>md', ':MoltenDelete<CR>', { desc = 'delete Molten cell', silent = true })
      vim.keymap.set('n', '<leader>ms', ':MoltenImagePopup<CR>', { desc = 'Show images in exteral viewer', silent = true })
      vim.keymap.set('n', '<leader>mh', ':MoltenHideOutput<CR>', { desc = 'close output window', silent = true })
      -- if you work with html outputs:
      vim.keymap.set('n', '<leader>mx', ':MoltenOpenInBrowser<CR>', { desc = 'open output in browser', silent = true })
      vim.keymap.set('n', '<leader>mi', function()
        local venv = os.getenv 'DIRENV_DIR' or os.getenv 'CONDA_PREFIX' or os.getenv 'VIRTUAL_ENV'
        if venv ~= nil then
          -- in the form of /home/user/.virtualenvs/VENV_NAME
          venv = string.match(venv, '/.+/(.+)')
          print(venv)
          vim.cmd(('MoltenInit %s'):format(venv))
        else
          vim.cmd 'MoltenInit'
        end
      end, { desc = 'Initialize the plugin', silent = true })
    end,
  },
  -- TODO: Treesitter setup https://github.com/benlubas/molten-nvim/blob/main/docs/Notebook-Setup.md#treesitter-text-objects
}
