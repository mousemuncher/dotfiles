--- @file telescope.lua
--- @brief Highly extensible fuzzy finder for lists and files.
--- This module configures the main picker engine, including UI behavior,
--- quickfix integration, and specialized search shortcuts.

return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  --- @brief Configures search defaults and keybindings.
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- =========================================================================
    -- 1. TELESCOPE SETUP
    -- =========================================================================
    telescope.setup({
      defaults = {
        -- Show only the relevant part of the file path.
        path_display = { "smart" },

        -- Disable Treesitter in previewer to maintain high performance
        -- when scrolling through large files.
        preview = {
          treesitter = false,
        },

        mappings = {
          i = {
            -- Navigation within the picker
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,

            -- Quickfix list management
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- =========================================================================
    -- 2. KEYBINDINGS
    -- =========================================================================
    local builtin = require("telescope.builtin")

    -- Standard file and buffer pickers
    vim.keymap.set("n", "<leader>pf", builtin.find_files, {
      desc = "Telescope: Find files",
    })
    vim.keymap.set("n", "<C-p>", builtin.git_files, {
      desc = "Telescope: Git files",
    })
    vim.keymap.set("n", "<leader>ps", builtin.live_grep, {
      desc = "Telescope: Live grep",
    })
    vim.keymap.set("n", "<leader>pb", builtin.buffers, {
      desc = "Telescope: Buffers",
    })
    vim.keymap.set("n", "<leader>vh", builtin.help_tags, {
      desc = "Telescope: Help tags",
    })

    --- Grep for the word currently under the cursor (Project-wide).
    vim.keymap.set("n", "<leader>pws", function()
      builtin.grep_string({ search = vim.fn.expand("<cword>") })
    end, { desc = "Telescope: Grep word under cursor" })
  end,
}
