local map = vim.keymap.set

map("n", "<leader>rm", function()
  QuickTerm("make ", true)
end, { desc = "make -" })

map("n", "<leader>rr", function()
  QuickTerm("make run")
end, { desc = "make run" })
