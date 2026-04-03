-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.lsp.enable("qmll6")
vim.lsp.config("qmlls", {
  cmd = { "qmlls" },
})
