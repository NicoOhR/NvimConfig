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
    lazy = false,
    init = function()
      vim.g.vimtex_compiler_latexmk = {
        build_dir = 'build',
      }

      vim.g.vimtex_view_method = "zathura"
      vim.g.setlocalleader = ","
    end
  },
}
