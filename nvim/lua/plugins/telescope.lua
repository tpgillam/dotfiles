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
        vim.keymap.set('n', '<leader>ps', function() builtin.grep_string(theme) end, {})
        vim.keymap.set('n', '<leader>pc', function() builtin.git_bcommits(theme) end, {})
        vim.keymap.set('n', '<leader>pb', function() builtin.buffers(theme) end, {})
        vim.keymap.set('n', '<leader>sm', function() builtin.man_pages(theme) end, {})
        vim.keymap.set('n', '<C-p>', function() builtin.git_files(theme) end, {})
        vim.keymap.set('n', '<leader>th', function() builtin.colorscheme(theme) end, {})

        telescope.setup {
            pickers = {
                find_files = {
                    -- Enable showing hidden files (dotfiles & those in .gitignore) in file finder.
                    hidden = true,
                    no_ignore = true
                },
                git_files = {
                    file_ignore_patterns = { "^archived_.*/" },
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
                    "--glob", "!{.git/**,archived_*}",
                }
            }
        }
    end
}
