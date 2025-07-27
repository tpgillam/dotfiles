return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        -- Adding `opt = {}` ensures that the plugin has setup() called
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = {
        automatic_enable = true,
        -- Here we ensure that specific plugins that we need are installed.
        -- NOTE: we specify the plugins by LSP name, _not_ package name.
        --  e.g. the "julia-lsp" package provides the "julials" language server.
        ensure_installed = {
            "julials",
            "lua_ls",
            "taplo"
        }
    },
}
