-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Continue" })
map("n", "<F6>", function()
  require("dap").step_over()
end, { desc = "Step Over" })
map("n", "<F7>", function()
  require("dap").step_into()
end, { desc = "Step Into" })
map("n", "<F8>", function()
  require("dap").step_out()
end, { desc = "Step Out" })

map("n", "gf", function()
  if vim.bo.filetype == "htmldjango" then
    local word = vim.fn.expand("<cfile>")
    local path = vim.fn.findfile(word, vim.fn.getcwd() .. "/*/templates/**," .. vim.fn.getcwd() .. "/*/*/templates/**")
    if path then
      vim.notify("Opening: " .. path)
      vim.cmd("edit " .. path)
      return
    end
    vim.notify("Template not found: " .. word, vim.log.levels.WARN)
  end
  vim.cmd("normal! gf")
end, { desc = "Go to file (with htmldjango)" })
