-- nvim-cmp has intelligent autocompletion from one or more "sources".
--      One such source is the LSP (Language Server Protocol), which lets this
--      work well with any language which has such integration.
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
            mapping = cmp.mapping.preset.insert({
                ["<C-space>"] = cmp.mapping.complete(),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-e>"] = cmp.mapping.close(),
            }),
            -- TODO: Remove buffer, path, cmdline from here and above if not using?
            sources = cmp.config.sources(
                {
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "vsnip" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "cmdline" },
                }
            ),
            completion = {
                autocomplete = false  -- Don't show the completion menu unless triggered.
            },
        })
    end
}

