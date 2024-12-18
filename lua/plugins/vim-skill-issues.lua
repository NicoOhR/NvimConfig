return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  { "nvchad/volt", lazy = true },
  { "nvchad/menu", lazy = true, dependencies = { { "nvzone/minty" } } },
  {
    "folke/twilight.nvim",
    config = function()
      local twilight = require("twilight")
      if twilight then
        vim.keymap.set('n', '<F2>', ':Twilight<CR>')
      end
    end
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
}
