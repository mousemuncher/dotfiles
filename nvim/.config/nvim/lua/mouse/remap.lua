--- @file remap.lua
--- @brief Custom keybindings for Neovim navigation and productivity.
--- This file defines leader-based shortcuts and overrides for common
--- editing patterns.

-- NOTE: mapleader is set in lazy.lua before plugins load.
-- Do not set it again here.

-- 1. FILE EXPLORATION & NAVIGATION

-- Open Netrw file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--- Move selected lines up/down in visual mode with auto-indenting
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--- Join lines while keeping the cursor at the start
vim.keymap.set("n", "J", "mzJ`z")

--- Scrolling and searching while keeping the cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- 2. CLIPBOARD & REGISTER MANAGEMENT

--- Paste without losing the current buffer (Greatest Hit)
vim.keymap.set("x", "<leader>p", [["_dP]])

--- Yank to system clipboard (+ register)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

--- Delete to void register (prevents overwriting clipboard)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- 3. LSP & UTILITIES

-- Restart LSP (useful for Zig/ZLS or stuck servers)
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- Format current buffer via LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Escape insert mode with Ctrl-C
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Ex-mode
vim.keymap.set("n", "Q", "<nop>")

-- Search and replace the word currently under the cursor
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
)

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- 4. NAVIGATION: QUICKFIX & LOCATION LISTS

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- 5. CUSTOM SNIPPETS & FUNCTIONS

--- Go-style error handling snippet
vim.keymap.set(
  "n",
  "<leader>ee",
  "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

--- Reload configuration (Source)
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- Clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", {
  desc = "Clear search highlights",
})

-- Math operations
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- 6. PROJECT & FILE MANAGEMENT

--- Open explorer at project root
vim.keymap.set("n", "<leader>pr", function()
  vim.cmd("Explore " .. vim.fn.getcwd())
end, { desc = "Project root explorer" })

--- Create new file relative to current directory
vim.keymap.set("n", "<leader>nf", function()
  local filename = vim.fn.input("New file (relative to current): ")
  if filename ~= "" then
    local current_dir = vim.fn.expand("%:p:h")
    vim.cmd("e " .. current_dir .. "/" .. filename)
  end
end, { desc = "New file in current dir" })

--- Create new file relative to project root
vim.keymap.set("n", "<leader>nF", function()
  local filename = vim.fn.input("New file (from root): ")
  if filename ~= "" then
    vim.cmd("e " .. vim.fn.getcwd() .. "/" .. filename)
  end
end, { desc = "New file from project root" })

-- 7. BUILD TOOLS & TERMINAL (GRADLE)

--- Helper for Gradle commands in a terminal split
local function gradle_cmd(task)
  local cmd = "below terminal cd "..vim.fn.getcwd().." && ./gradlew " .. task
  vim.cmd(cmd)
end

vim.keymap.set("n", "<leader>gr", function() gradle_cmd("run") end, {
  desc = "Gradle run",
})
vim.keymap.set("n", "<leader>gb", function() gradle_cmd("build") end, {
  desc = "Gradle build",
})
vim.keymap.set("n", "<leader>gt", function() gradle_cmd("test") end, {
  desc = "Gradle test",
})

--- Open terminal split at project root
vim.keymap.set("n", "<leader>tt", function()
  vim.cmd("below terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal at project root" })
