return {
  {
    "ellisonleao/gruvbox.nvim",
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
}
