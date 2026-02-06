---@diagnostic disable-next-line: unused-local
local actions = require("telescope.actions")

local open_multiple = function(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", j.path))
      end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<CR>"] = open_multiple,
        },
        n = {
          ["<CR>"] = open_multiple,
        },
      },
    },
  },
}
