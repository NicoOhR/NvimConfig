return {
  {
    "ellisonleao/gruvbox.nvim",
  },
  {
    "rose-pine/neovim",
  },
  {
    'comfysage/evergarden',
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      transparent_background = true,
      contrast_dark = 'hard', -- 'hard'|'medium'|'soft'
      overrides = {},         -- add custom overrides
    }
  },
  {
    "0xstepit/flow.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("flow").setup()
    end,
    opts = {
      contrast = "high"
    },
  }
}
