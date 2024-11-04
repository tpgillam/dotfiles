return {
    {
        "vim-airline/vim-airline",
        config = function()
            vim.g.airline_powerline_fonts = 1

            vim.g.airline_left_sep = ''
            vim.g.airline_left_alt_sep = ''
            vim.g.airline_right_sep = ''
            vim.g.airline_right_alt_sep = ''

            vim.g.airline_theme = "bubblegum"
        end
    },
    { "vim-airline/vim-airline-themes" },
}
