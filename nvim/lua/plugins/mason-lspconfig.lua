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
            }
        }

        -- Now we can set up the language servers we want...
        require("lspconfig").julials.setup {}
        require("lspconfig").lua_ls.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        -- Recognise various globals that are used by tools I configure.
                        globals = { "vim" }
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('', true),
                    }
                }
            }
        }
    end
}
