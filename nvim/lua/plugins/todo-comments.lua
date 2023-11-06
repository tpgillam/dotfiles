return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        signs = false,  -- No gutter signs for me.
        highlight = {
            keyword = "bg",  -- The default makes it impossible to see the surrounding characters
        },
    },
}
