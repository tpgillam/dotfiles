-- All plugins which are just colorschemes.
return {
    {
        "rockyzhang24/arctic.nvim",
        branch = "v2",
        dependencies = { "rktjmp/lush.nvim" },
    },
    {
        "metalelf0/jellybeans-nvim",
        dependencies = { "rktjmp/lush.nvim" },
    },
    { "savq/melange-nvim" },
    { "EdenEast/nightfox.nvim" },
    { "romainl/Apprentice" },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = { no_italic = true }
    },
    { "vague-theme/vague.nvim" },
    { "thesimonho/kanagawa-paper.nvim" },
}
