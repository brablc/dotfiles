-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.filetype.add({
  extension = {
    tpl = function(path, bufnr)
      local base = vim.fn.fnamemodify(path, ":r")
      return vim.filetype.match({ filename = base })
    end,
    tftpl = function(path, bufnr)
      local base = vim.fn.fnamemodify(path, ":r")
      return vim.filetype.match({ filename = base })
    end,
    j2 = function(path, bufnr)
      local base = vim.fn.fnamemodify(path, ":r")
      return vim.filetype.match({ filename = base })
    end,
  },
  pattern = {
    [".*/templates/.*/.*%.html"] = "htmldjango",
    [".*logstash.*/.*%.conf"] = "logstash",
    [".*%.logstash%.conf"] = "logstash",
  },
})
