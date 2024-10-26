return {
  {
    "ibhagwan/smartyank.nvim",
    event = "VeryLazy",
    opts = {
      -- Default configuration
      highlight = {
        enabled = true, -- highlight yanked text
        higroup = "IncSearch", -- highlight group of yanked text
        timeout = 200, -- timeout for highlighting in milliseconds
      },
      clipboard = {
        enabled = true, -- enable system clipboard integration
      },
      tmux = {
        enabled = true, -- enable tmux integration
        -- set tmux paste buffer instead of unnamed register when yanking
        set_clipboard = true,
      },
      osc52 = {
        enabled = true, -- enable osc52 integration (useful for SSH)
        ssh_options = {
          enable = true, -- enable automatic SSH detection
        },
      },
    },
  },
}
