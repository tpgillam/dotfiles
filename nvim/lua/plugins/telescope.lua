return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- Use fzf-native with telescope
        local telescope = require("telescope")
        telescope.load_extension("fzf")

        local builtin = require('telescope.builtin')
        local theme = require("telescope.themes").get_ivy()
        vim.keymap.set('n', '<leader>pf', function() builtin.find_files(theme) end, {})
        vim.keymap.set('n', '<leader>pg', function() builtin.live_grep(theme) end, {})
        vim.keymap.set('n', '<leader>pb', function() builtin.buffers(theme) end, {})
        vim.keymap.set('n', '<C-p>', function() builtin.git_files(theme) end, {})
        vim.keymap.set('n', '<leader>th', function() builtin.colorscheme(theme) end, {})

        -- Enable showing hidden files (dotfiles & those in .gitignore) in file finder.
        telescope.setup {
            pickers = {
                find_files = {
                    hidden = true,
                    no_ignore = true
                }
            },
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    -- Custom arguments follow!
                    -- Also search hidden files and folders, except `.git`.
                    "--hidden",
                    "--glob", "!.git/**",
                }
            }
        }
    end
}
