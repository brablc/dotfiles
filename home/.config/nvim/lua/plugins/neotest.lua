return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
      "fredrikaverpil/neotest-golang",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = ".venv/bin/python",
          dap = { justMyCode = false },
        },
      },
    },
  },
}
