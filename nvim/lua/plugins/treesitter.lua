-- nvim-treesitter
--
-- NOTE: this plugin was archived 2026-04-03; consider how the situation evolves.
--  Currently this requires `tree-sitter` to be on the PATH.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy-loading
    build = ":TSUpdate",
    config = function()
        local nts = require("nvim-treesitter")
        nts.setup()

        local ensure_installed = {
            "bash",
            "c",
            "glsl",
            "html",
            "javascript",
            "json",
            "julia",
            "lua",
            "markdown",
            "markdown_inline", -- needed alongside `markdown`
            "python",
            "rust",
            "vim",
            "vimdoc",
        }
        -- `main` has no `ensure_installed` option; reproduce something similar by hand.
        local installed = nts.get_installed()
        local missing = vim.iter(ensure_installed)
            :filter(function(lang) return not vim.tbl_contains(installed, lang) end)
            :totable()
        if #missing > 0 then
            nts.install(missing):wait(300000)
        end

        -- On `main`, highlighting and indentation are no longer auto-enabled by the
        -- plugin; opt in per-buffer. (Folding is set globally below.)
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                -- pcall: filetypes without an installed parser shouldn't error.
                if pcall(vim.treesitter.start) then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })

        -- Treesitter folding (core foldexpr). Folds open by default.
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.o.foldenable = true
        vim.o.foldlevel = 99
    end,
}
