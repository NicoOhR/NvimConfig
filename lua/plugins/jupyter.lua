return{
  "luk400/vim-jukit",
  lazy = true,
  ft = { "python", "ipynb" },
  event = {"VeryLazy"},
  init = function()
    vim.g.jukit_shell_cmd = "ipython"
  end,
}

