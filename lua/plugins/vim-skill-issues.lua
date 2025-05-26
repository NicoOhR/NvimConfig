return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
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
    dependencies = { { "echasnovski/mini.icons", opts = {} } },

  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      indent = {
        enabled = true,
        animate = {
          enabled = false,
        },
      },
    },
  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      { "gb", function() require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu" }
    },
    opts = {}
  },
}
