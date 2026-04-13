return {
  "mattn/emmet-vim",
  ft   = { "html", "css", "htmldjango" },
  init = function()
    -- Expand with <C-e>,
    vim.g.user_emmet_leader_key = "<C-e>"
  end,
}
