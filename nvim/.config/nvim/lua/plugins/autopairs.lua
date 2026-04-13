return {
  "windwp/nvim-autopairs",
  event  = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true, -- use treesitter to check pairs
    })
    -- Hook into nvim-cmp so pairs work with completions
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp           = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
