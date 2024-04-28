return {
    "williamboman/mason-lspconfig",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
        -- Here we ensure that specific plugins that we need are installed.
        -- NOTE: we specify the plugins by LSP name, _not_ package name.
        --  e.g. the "julia-lsp" package provides the "julials" language server.
        require("mason-lspconfig").setup {
            ensure_installed = {
                "julials",
                "lua_ls",
                "ruff_lsp",
                "pyright",
                "taplo"
            }
        }

        -- Now we can set up the language servers we want...
        require("lspconfig").julials.setup {}
        require("lspconfig").lua_ls.setup {
            settings = {
                Lua = {
                    -- Load the neovim API, to avoid 'undefined global' errors.
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('lua', true),
                    },
                    telemetry = {
                        enable = false,
                    }
                }
            }
        }
        require("lspconfig").ruff_lsp.setup {}
        require("lspconfig").pyright.setup {}
        require("lspconfig").taplo.setup {}
    end
}
