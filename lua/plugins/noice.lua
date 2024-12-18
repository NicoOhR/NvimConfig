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
            ["vim.lsp.util.open_floating_preview"] = true,
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
        routes = {
          {
            filter = {
              event = "notify",
              find = "server cancelled the request",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "lsp",
              kind = "message",
              find = "ormolu: Internal Error: ormoluCmd: OrmoluParsingFailed",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "notify",
              find = "Format request failed, no matching language servers.",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "msg_show",
              find = "written",
            },
            opts = { skip = true },
          },
        },
      })
    end,
  }
}
