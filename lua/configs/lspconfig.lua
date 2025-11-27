require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "tsserver", "lua_ls", "pylsp" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
