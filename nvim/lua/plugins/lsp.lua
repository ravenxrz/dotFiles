return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
    },
    config = function()
      -- vim.lsp.set_log_level("error")
      vim.lsp.set_log_level("off")
      -- setup lsp
      -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      -- for supported languages
      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      -- vim.keymap.set('n', '<c-q>', vim.diagnostic.setloclist)
      -- vim.keymap.set("n", "<leader>lf", "vim.lsp.buf.formatting")
      -- vim.keymap.set('v', '<leader>lf', "<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>")

      -- diagnostic
      vim.diagnostic.config({ virtual_text = false })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, opts)
          -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
    end
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
    },
    config = function()
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          if server_name == "clangd" then
            require("lspconfig")[server_name].setup {
              cmd = {
                "clangd",
                "--background-index", -- 后台建立索引，并持久化到disk
                "--clang-tidy",       -- 开启clang-tidy
                -- 指定clang-tidy的检查参数， 摘抄自cmu15445. 全部参数可参考 https://clang.llvm.org/extra/clang-tidy/checks
                "--clang-tidy-checks=bugprone-*, clang-analyzer-*, google-*, modernize-*, performance-*, portability-*, readability-*, -bugprone-too-small-loop-variable, -clang-analyzer-cplusplus.NewDelete, -clang-analyzer-cplusplus.NewDeleteLeaks, -modernize-use-nodiscard, -modernize-avoid-c-arrays, -readability-magic-numbers, -bugprone-branch-clone, -bugprone-signed-char-misuse, -bugprone-unhandled-self-assignment, -clang-diagnostic-implicit-int-float-conversion, -modernize-use-auto, -modernize-use-trailing-return-type, -readability-convert-member-functions-to-static, -readability-make-member-function-const, -readability-qualified-auto, -readability-redundant-access-specifiers,",
                "--completion-style=detailed",
                "--cross-file-rename=true",
                "--header-insertion=iwyu",
                "--pch-storage=memory",
                -- 启用这项时，补全函数时，将会给参数提供占位符，键入后按 Tab 可以切换到下一占位符
                "--function-arg-placeholders=false",
                "--log=verbose",
                "--ranking-model=decision_forest",
                -- 输入建议中，已包含头文件的项与还未包含头文件的项会以圆点加以区分
                "--header-insertion-decorators",
                "-j=12",
                "--pretty",
                 "--offset-encoding=utf-16",
              },
              capabilities = require("cmp_nvim_lsp").default_capabilities()
            }
          else
            require("lspconfig")[server_name].setup {
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }
          end
        end,
      }
    end
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      {
        "jose-elias-alvarez/null-ls.nvim",
      },
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        debug = false,
        sources = {
          null_ls.builtins.diagnostics.cpplint.with({
              -- override args completely to make sure ordering is correct
              args = { "--filter=-legal/copyright,-build/include_subdir,-whitespace/line_length,-readability/casting", "$FILENAME" },
            },
            null_ls.builtins.code_actions.cpplint
          )
        }
      })
      require("mason-null-ls").setup({
        automatic_setup = true,
        ensure_installed = {
          "isort@5.11.5",
          "cpplint",
          "shfmt"
        },
        handlers = {},
      })
    end,
  }
}
