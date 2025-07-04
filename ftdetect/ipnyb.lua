vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ipynb",
  callback = function() vim.cmd("setfiletype ipynb") end,
})

