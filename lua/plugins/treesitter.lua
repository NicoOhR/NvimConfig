return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.config")
      config.setup({
        auto_install = true,
        highlight = { enable = true, disable = { "fortran" }, },
        indent = { enable = true },
      })
    end
  }
}
