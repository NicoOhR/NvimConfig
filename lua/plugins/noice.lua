return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    init = function()
      require("noice").setup({
        lsp = {
          -- Override markdown rendering for Treesitter support
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = {
          command_palette = false,
          bottom_search = false,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true, -- adds a border to hover docs and signature help
        },
        cmdline = {
          view = "cmdline", -- Use the classic bottom cmdline
        },
      })
    end,
  }
}
