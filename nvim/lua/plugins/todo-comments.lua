return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        signs = false,  -- No gutter signs for me.
        highlight = {
            keyword = "bg",  -- The default ("wide") makes it hard to see the surrounding characters
            after = "",  -- Don't highlight the rest of the comment (default is "fg").
        },
    },
}
