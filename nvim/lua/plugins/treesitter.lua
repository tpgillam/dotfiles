return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "bash",
                "c",
                "html",
                "javascript",
                "julia",
                "lua",
                "markdown",
                "python",
                "rust",
                "vim",
                "vimdoc",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })

        vim.cmd.set("foldmethod=expr")
        vim.cmd.set("foldexpr=nvim_treesitter#foldexpr()")
        vim.cmd.set("nofoldenable")
    end
}
