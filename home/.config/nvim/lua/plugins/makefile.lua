return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        autotools_ls = {
          mason = false,
          autostart = true,
          cmd = { os.getenv("HOME") .. "/.local/share/nvim-venv/bin/autotools-language-server" },
        },
      },
    },
  },
}
