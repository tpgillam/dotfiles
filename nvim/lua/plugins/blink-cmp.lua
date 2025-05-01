return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' }, -- optional: provides snippets for the snippet source

    -- use a release tag to download pre-built binaries
    version = '1.*',

    opts = {
        keymap = {
            preset = 'enter',                   -- enter to complete, not C-y
            ["<C-space>"] = { "show", "hide" }, -- toggle menu itself rather than docs
        },
        completion = {
            accept = {
                auto_brackets = { enabled = false }, -- no auto brackets please, thank you.
            },
            documentation = {
                auto_show = true,       -- Show documentation when showing menu...
                auto_show_delay_ms = 0, -- ... without lag.
            },
            list = {
                selection = {
                    preselect = false,
                },
            },
            menu = {
                auto_show = false, -- Don't show the completion menu unless triggered.

                -- A bit bit more information that the default
                draw = {
                    columns = {
                        { "label",     "label_description", gap = 1 },
                        { "kind_icon", "kind",              gap = 1 }
                    },
                }

            },
        },

        -- Signature support is experimental, and the default keybinding (C-k) clashes
        -- with insertion of digraphs.
        signature = { enabled = false },

        -- Don't fall back to the lua implementation. Force me to fix it.
        fuzzy = { implementation = "rust" }
    },
}
