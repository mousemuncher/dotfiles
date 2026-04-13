--- @file lazy.lua
--- @brief Neovim configuration entry point and plugin manager bootstrap.
--- This script ensures that the `lazy.nvim` plugin manager is installed,
--- configures basic editor options, and initializes the plugin system.

-- 1. BOOTSTRAP PLUGIN MANAGER (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

--- Check if lazy.nvim is already installed; if not, clone it from GitHub.
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"

  -- Clone the repository using a partial clone for efficiency.
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })

  -- Handle potential git errors during the cloning process.
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Prepend the newly installed manager to the runtime path.
vim.opt.rtp:prepend(lazypath)

-- 2. GLOBAL EDITOR OPTIONS & MAPPINGS
--
-- Enable 24-bit RGB colors in the TUI.
vim.opt.termguicolors = true

-- 3. PLUGIN SETUP

--- Initialize the plugin manager with custom specifications.
-- @param spec A table containing the plugins to import or define.
-- @param install Configuration for automatic plugin installation.
require("lazy").setup({
  spec = {
    -- Import plugin specifications from the 'lua/plugins' directory.
    { import = "plugins" },
  },
  install = {
    -- Fallback colorscheme used during initial installation.
    colorscheme = { "habamax" },
  },
})
