return {
  {
    "brablc/gh-actions.nvim",
    branch = "patch-1",
    keys = {
      { "<leader>cg", "<cmd>GhActions<cr>", desc = "Open Github Actions" },
    },
    -- optional, you can also install and use `yq` instead.
    build = "yq",
    ---@type GhActionsConfig
    opts = {},
  },
}
