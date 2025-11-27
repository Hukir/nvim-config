-- ~/.config/nvim/lua/plugins/init.lua

return {
  -- Format (black pour Python, etc.)
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePre", -- tu peux laisser commenté, on gère le format via configs.conform
    opts = require "configs.conform",
  },

  -- LSP (pylsp, lua_ls, etc.)
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Linting (ruff pour Python via nvim-lint)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  -- Autocomplete (NvChad blink)
  {
    import = "nvchad.blink.lazyspec",
  },

  -- Exemple si tu veux réactiver treesitter plus tard :
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     ensure_installed = {
  --       "vim",
  --       "lua",
  --       "vimdoc",
  --       "html",
  --       "css",
  --       "python",
  --     },
  --   },
  -- },
}

