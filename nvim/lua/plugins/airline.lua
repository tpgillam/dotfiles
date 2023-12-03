return {
    {
        "vim-airline/vim-airline",
        config = function()
            vim.g.airline_powerline_fonts = 1

            vim.g.airline_left_sep = ''
            vim.g.airline_left_alt_sep = ''
            vim.g.airline_right_sep = ''
            vim.g.airline_right_alt_sep = ''

            -- For some reason, just overriding individual elements of this
            -- dictionary didn't work. Rather it seems necessary to define it
            -- from scratch.
            -- NOTE if we get runtime errors about missing elements from this dictionary,
            --  it may be necessary to define them.
            vim.g.airline_symbols = {
                branch = '',
                colnr = ' ℅:',
                readonly = '',
                linenr = ' :',
                maxlinenr = '☰ ',
                dirty = '⚡',
                space = ' ',
                notexists = 'Ɇ',
                whitespace = 'Ξ',
                keymap = 'Layout:', -- Unused, but this is the default
            }

            vim.g.airline_theme = "bubblegum"
        end
    },
    { "vim-airline/vim-airline-themes" },
}
