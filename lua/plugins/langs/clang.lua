return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {
          cmd = {
            'clangd', --dez nuts
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=Chromium',
            -- '--query-driver=/usr/bin/x86_64-w64-mingw32-g++',
            '--compile-commands-dir=build',
          },
        },
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    -- NOTE: Ensure C/C++ debugger is installed
    -- dependencies = { "mason-org/mason.nvim", optional = true, opts = { ensure_installed = { "codelldb" } }, },
    optional = true,
    opts = function()
      local dap = require 'dap'
      dap.adapters.codelldb = {
        type = 'executable',
        command = vim.env.CODELLDB_BIN,
      }
      for _, lang in ipairs { 'c', 'cpp' } do
        dap.configurations[lang] = {
          {
            type = 'codelldb',
            request = 'launch',
            name = 'Launch file',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
          },
          {
            type = 'codelldb',
            request = 'attach',
            name = 'Attach to process',
            pid = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        }
      end
    end,
  },
}
