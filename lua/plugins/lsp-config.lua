return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  }, {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "ocamllsp", "rust_analyzer", "tsserver", "clangd", "bufls" },
    })
  end,
},
  {
    "neovim/nvim-lspconfig",
    setup = {
    },
    opts = {
    },
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end,
          })
        end
      end

      vim.lsp.buf.format {
        filter = function(client) return client.name ~= "bufls" end
      }
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local noice = require("noice.lsp")
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "c", "cpp" }
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.ocamllsp.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.cmd("!ocamlformat %")
          end,
        })
      })
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.bufls.setup {
        on_attach = function(client, bufnr)
          -- Enable formatting capability
          client.server_capabilities.documentFormattingProvider = true
          -- Additional setup can go here
        end,
        -- Specify the command if not in your PATH
        cmd = { "bufls", "serve" },
        filetypes = { "proto" },
      }
      vim.lsp.inlay_hint.enable(true, { 0 })
      vim.keymap.set("n", "K", require("noice.lsp").hover, {})
      vim.keymap.set("n", "gt", vim.lsp.buf.definition, {})
      vim.diagnostic.config({
        virtual_text = false,     -- Disable virtual text
        signs = true,             -- Keep the signs (squiggly lines)
        underline = true,         -- Keep underlines for diagnostics
        update_in_insert = false, -- Do not show diagnostics while in insert mode
        severity_sort = true,     -- Sort diagnostics by severity
        float = {
          border = "rounded",
        }
      })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
