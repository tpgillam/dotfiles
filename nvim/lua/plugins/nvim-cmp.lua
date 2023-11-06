return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        -- One snipping tool needs to be chosen.
        -- `luasnip` seems to be popular, but vsnip (meant to be similar to VSCode)
        -- is by the same author as nvim-cmp so may be better integrated?
        "hrsh7th/vim-vsnip",
        "hrsh7th/cmp-vsnip",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            -- Use `vsnip`. Exactly one snippet tool must be configured (see github page
            --  for other choices).
            snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
            -- FIXME decide what I want here...
            -- window = { },
            sources = cmp.config.sources(
                {
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                },
                {
                    { name = "buffer" },
                }
            )
        })
    end
}
