return {
	"nvim-telescope/telescope.nvim", branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function ()
		-- Use fzf-native with telescope
		require('telescope').load_extension('fzf')

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
		vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
		vim.keymap.set('n', '<C-p>', builtin.git_files, {})
	end
}
