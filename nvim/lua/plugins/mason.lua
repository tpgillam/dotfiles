return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            -- Here we ensure that specific plugins that we need are installed.
            -- NOTE: we specify the plugins by LSP name, _not_ package name.
            --  e.g. the "julia-lsp" package provides the "julials" language server.
            require("mason-lspconfig").setup {
                ensure_installed = { "julials" }
            }

            -- Now we can set up the language servers we want...
            require("lspconfig").julials.setup {}
        end
    }
}
