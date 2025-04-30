return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' }, -- optional: provides snippets for the snippet source

    -- use a release tag to download pre-built binaries
    version = '1.*',

    opts = {
        completion = {
            accept = { auto_brackets = { enabled = false }, }, -- no auto brackets please thank you.
            documentation = { auto_show = true },              -- Show documentation when showing menu.
            menu = {
                auto_show = false,                             -- Don't show the completion menu unless triggered.

                -- A bit bit more information that the default
                draw = {
                    columns = {
                        { "label",     "label_description", gap = 1 },
                        { "kind_icon", "kind",              gap = 1 }
                    },
                }

            },
        },

        -- Don't fall back to the lua implementation. Force me to fix it.
        fuzzy = { implementation = "rust" }
    },
}
