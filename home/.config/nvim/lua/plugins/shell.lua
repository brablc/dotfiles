return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "shellcheck",
        "shfmt",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["sh"] = { "shfmt" }, -- Add shfmt for shell scripts
      },
      formatters = {
        shfmt = {
          command = "shfmt",
          args = { "-i", "2", "-ci", "-bn", "-simplify" }, -- Customize shfmt options
          stdin = true, -- Ensure it uses stdin for formatting
        },
      },
    },
  },
}
