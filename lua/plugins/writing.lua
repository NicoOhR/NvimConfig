return {
  { 'sheerun/vim-polyglot' },
  { 'preservim/vim-pencil' },
  { "folke/zen-mode.nvim" },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    }
  },
  {
    "lervag/vimtex",
    config = function()
    end,
    lazy = false,
  },
}
