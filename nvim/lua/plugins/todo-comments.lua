return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        signs = false,  -- No gutter signs for me.
        highlight = {
            -- The default ("wide") makes it hard to see the surrounding characters when combined
            -- with the default 'after' value.
            -- keyword = "bg",
            keyword = "wide",
            after = "",  -- Don't highlight the rest of the comment (default is "fg").
        },
    },
}
