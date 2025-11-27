local conform = require "conform"

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
  },
})

-- Format automatiquement AVANT chaque sauvegarde
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    conform.format({
      bufnr = args.buf,
      lsp_fallback = true,
      timeout_ms = 500,
    })
  end,
})

