local prefix = '<leader>o'
local date_format = '%d-%b-%Y'

return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*', -- '*' use latest release, remove to use latest commit
    ft = 'markdown',
    keys = {
      { prefix .. '<space>', '<cmd>Obsidian quick_switch<CR>', desc = 'Find Files' },
      { prefix .. 'o', '<cmd>Obsidian open<CR>', desc = 'Open on App' },
      { prefix .. 'g', '<cmd>Obsidian search<CR>', desc = 'Grep' },
      { prefix .. 'n', '<cmd>Obsidian new<CR>', desc = 'New Note' },
      { prefix .. 'N', '<cmd>Obsidian new_from_template<CR>', desc = 'New Note (Template)' },
      { prefix .. 'b', '<cmd>Obsidian backlinks<CR>', desc = 'Backlinks' },
      { prefix .. 't', '<cmd>Obsidian tags<CR>', desc = 'Tags' },
      { prefix .. 'T', '<cmd>Obsidian template<CR>', desc = 'Template' },
      { prefix .. 'L', '<cmd>Obsidian link<CR>', mode = 'v', desc = 'Link' },
      { prefix .. 'l', '<cmd>Obsidian links<CR>', desc = 'Links' },
      { prefix .. 'l', '<cmd>Obsidian link_new<CR>', mode = 'v', desc = 'New Link' },
      { prefix .. 'e', '<cmd>Obsidian extract_note<CR>', mode = 'v', desc = 'Extract Note' },
      { prefix .. 'w', '<cmd>Obsidian workspace<CR>', desc = 'Workspace' },
      { prefix .. 'r', '<cmd>Obsidian rename<CR>', desc = 'Rename' },
      { prefix .. 'i', '<cmd>Obsidian paste_img<CR>', desc = 'Paste Image' },
      { prefix .. 'd', '<cmd>Obsidian dailies<CR>', desc = 'Daily Notes' },
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in the next major release
      workspaces = {
        {
          name = 'personal',
          path = '~/Documents/notes',
        },
      },
      templates = {
        folder = 'res/templates',
        date_format = date_format,
        time_format = '%H:%M',
      },
      daily_notes = {
        folder = 'daily',
        date_format = date_format,
        alias_format = nil,
        default_tags = { 'daily' },
        workdays_only = false,
      },
      picker = {
        name = 'snacks.pick',
        note_mappings = {
          new = '<C-x>',
          insert_link = '<C-l>',
        },
        tag_mappings = {
          tag_note = '<C-x>',
          insert_tag = '<C-l>',
        },
      },
      completions = {
        nvim_cmp = true,
      },
      image = {
        resolve = function(path, src)
          if require('obsidian.api').path_is_note(path) then
            return require('obsidian.api').resolve_image_path(src)
          end
        end,
      },
    },
  },
  {
    'folke/snacks.nvim',
    keys = {
      {
        prefix .. 'k',
        function()
          Snacks.picker.grep {
            search = '^\\s*- \\[ \\]',
            regex = true,
            dirs = { vim.fn.getcwd() },
            finder = 'grep',
            format = 'file',
            show_empty = true,
            supports_live = false,
            live = false,
          }
        end,
        desc = 'Tasks (Unfinished)',
      },
      {
        prefix .. 'K',
        function()
          Snacks.picker.grep {
            search = '^\\s*- \\[x\\]:',
            regex = true,
            dirs = { vim.fn.getcwd() },
            finder = 'grep',
            format = 'file',
            show_empty = true,
            supports_live = false,
            live = false,
          }
        end,
        desc = 'Tasks (Finished)',
      },
    },
  },
  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        { prefix, group = 'obsidian', icon = ' ', mode = { 'n', 'v' } },
      },
    },
  },
}
