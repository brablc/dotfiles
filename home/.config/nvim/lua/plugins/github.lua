return {
  {
    "topaxi/gh-actions.nvim",
    keys = {
      { "<leader>cg", "<cmd>GhActions<cr>", desc = "Open Github Actions" },
    },
    -- optional, you can also install and use `yq` instead.
    build = "yq",
    ---@type GhActionsConfig
    opts = {},
  },
}
