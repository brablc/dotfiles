--
-- https://www.lazyvim.org/extras/editor/snacks_explorer#snacksnvim
--
return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {},
      picker = {
        sources = {
          explorer = {
            layout = {
              preview = { main = true, enabled = false },
            },
          },
        },
      },
    },
  },
}
