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
    dependencies = { { "echasnovski/mini.icons", opts = {} } },

  },
  {
    "echasnovski/mini.pairs",
    version = '*',
    config = function()
      require('mini.pairs').setup()
    end
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
}
