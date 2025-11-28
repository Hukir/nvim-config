require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- tes mappings existants
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- ---- Run Python in a reusable terminal (sans changer de fenêtre) ----
local function run_python_in_term()
  -- sauvegarde le fichier courant
  vim.cmd "w"

  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file name", vim.log.levels.WARN)
    return
  end

  -- on garde la fenêtre actuelle pour y rester
  local cur_win = vim.api.nvim_get_current_win()

  -- créer le terminal si besoin
  if
    not vim.g.python_term_winid
    or not vim.api.nvim_win_is_valid(vim.g.python_term_winid)
    or not vim.g.python_term_bufnr
    or not vim.api.nvim_buf_is_valid(vim.g.python_term_bufnr)
  then
    vim.cmd "botright 15split"
    vim.cmd "terminal"

    vim.g.python_term_winid = vim.api.nvim_get_current_win()
    vim.g.python_term_bufnr = vim.api.nvim_get_current_buf()
    vim.g.python_term_chanid = vim.b.terminal_job_id

    -- revenir dans la fenêtre d'origine
    vim.api.nvim_set_current_win(cur_win)
  end

  -- envoyer la commande au terminal (sans déplacer le focus)
  local cmd = "clear && python3 " .. vim.fn.shellescape(file) .. "\n"
  vim.fn.chansend(vim.g.python_term_chanid, cmd)
end

-- Space + r -> run le fichier Python courant dans le terminal réutilisable
map("n", "<leader>r", run_python_in_term, { desc = "Run current Python file" })

-- Fermer le terminal Python quand on quitte un buffer Python
local group = vim.api.nvim_create_augroup("PythonRunTerm", { clear = true })

vim.api.nvim_create_autocmd({ "BufWipeout", "BufUnload", "BufDelete" }, {
  group = group,
  pattern = "*.py",
  callback = function()
    if vim.g.python_term_winid and vim.api.nvim_win_is_valid(vim.g.python_term_winid) then
      pcall(vim.api.nvim_win_close, vim.g.python_term_winid, true)
    end
    vim.g.python_term_winid = nil
    vim.g.python_term_bufnr = nil
    vim.g.python_term_chanid = nil
  end,
})

-- === Complétion LSP simple avec <C-Space> ===
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"

map("i", "<C-Space>", "<C-x><C-o>", { desc = "LSP omni completion" })
