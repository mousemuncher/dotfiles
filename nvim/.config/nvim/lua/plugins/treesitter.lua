--- @file treesitter.lua
--- @brief Configuration for Treesitter parsing and syntax highlighting.
--- Treesitter provides faster, more accurate syntax highlighting and
--- indentation by building a concrete syntax tree of the source code.
---
--- NOTE: The 'main' branch of nvim-treesitter is a complete rewrite.
--- Highlighting/indentation are no longer enabled via plugin config —
--- you must use Neovim's native vim.treesitter.start() API instead.

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local ts = require("nvim-treesitter")

    -- Only option the main branch setup accepts is install_dir.
    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- List of parsers to maintain.
    local parsers = {
      "vimdoc",
      "javascript",
      "typescript",
      "c",
      "lua",
      "rust",
      "jsdoc",
      "bash",
      "html",
      "css",
      "tsx",
      "json",
    }

    -- Install parsers asynchronously (no-op if already installed).
    -- Deferred so it runs after setup() completes.
    vim.defer_fn(function()
      ts.install(parsers)
    end, 0)

    -- Build the list of filetypes that have parsers, so we only
    -- enable treesitter for languages we actually support.
    local patterns = {}
    for _, parser in ipairs(parsers) do
      local filetypes = vim.treesitter.language.get_filetypes(parser)
      for _, ft in ipairs(filetypes) do
        table.insert(patterns, ft)
      end
    end

    -- Enable treesitter-based highlighting and indentation
    -- via Neovim's native API (required on the main branch).
    -- Guarded with pcall so missing parsers don't crash on first launch.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = patterns,
      callback = function()
        local ok, err = pcall(vim.treesitter.start)
        if ok then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

  end,
}
