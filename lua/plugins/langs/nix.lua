return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    opts = {
      servers = {
        -- nixd is preferred; nil is also installed via nix but disabled here.
        -- (LazyVim's nix extra enables nil_ls by default.)
        nil_ls = {
          enabled = false,
        },
        nixd = {
          settings = {
            nixpkgs = {
              -- For flake.
              -- This expression will be interpreted as "nixpkgs" toplevel
              -- Nixd provides package, lib completion/information from it.
              -- Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
              -- Package documentation, versions, are evaluated by-need.
              expr = 'import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }',
            },
            formatting = {
              command = 'nixfmt', -- or nixpkgs-fmt
            },
          },
        },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { 'nixfmt' },
      },
    },
  },
}
