--- @file set.lua
--- @brief Global Neovim settings and editor behavior configurations.
--- This file handles indentation, search behavior, undo persistence,
--- and language-specific buffer settings via autocommands.

-- NOTE: mapleader is set in lazy.lua before plugins load.
-- Do not set it again here.

-- 0. DISABLE UNUSED PROVIDERS
-- Silences checkhealth warnings for providers we don't use.
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_ruby_provider    = 0

-- 1. IDENTATION & TABULATION
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- 2. UI & APPEARANCE
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "100"

-- Cursor behavior for file paths
vim.opt.isfname:append("@-@")

-- 3. SEARCH BEHAVIOR
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 4. UNDO & BACKUP PERSISTENCE
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- 5. SYSTEM & INTERACTION
vim.opt.updatetime = 50
vim.opt.shell = "/bin/bash"
vim.opt.clipboard = "unnamedplus"

-- Configure backspace to behave like other editors
vim.opt.backspace = "indent,eol,start"

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 6. DIAGNOSTICS CONFIGURATION
--
--- Define how LSP diagnostics are displayed in the UI.
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- 7. AUTOCOMMANDS (LANGUAGE SPECIFIC)
--
--- Web Development: Set indentation to 2 spaces.
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "html",
    "css",
    "json",
    "jsx",
    "tsx",
    "lua",
    "svelte",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

--- C/C++: Set indentation to 8-width tabs and enable C-style indenting.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.expandtab = false
    vim.opt_local.cindent = true
    vim.opt_local.cinoptions = ":0,l1,t0,+4,(0,u0,w1"
    vim.opt_local.autoindent = true
  end,
})
