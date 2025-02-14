return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- The following are optional:
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "copilot",
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "cmd:op read 'op://Private/Claude.ai Neovim API Key/credential' --no-newline",
            },
          })
        end,
      },
    },
  },
  {
    "augmentcode/augment.vim",
    init = function()
      vim.g.augment_workspace_folders = { "~/Projects" }
      vim.g.augment_disable_tab_mapping = true
      vim.keymap.set("n", "<leader>al", function()
        vim.cmd("Augment chat " .. vim.api.nvim_get_current_line())
      end, { desc = "Augment chat with current line" })
      vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>Augment chat<CR>")
      vim.keymap.set("n", "<leader>at", "<cmd>Augment chat-toggle<CtR>")
      vim.keymap.set("i", "<C-a>", "<cmd>call augment#Accept()<CR>", { silent = true })
    end,
  },
}
