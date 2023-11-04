require("lazy_bootstrap")

vim.g.mapleader = " "

-- Packages should be initialised _after_ remapping the <leader>
require("lazy").setup(
	"plugins",  -- This will load all files in the `plugins` module.
	{
        -- Make it easier to see the edge of the Lazy plugin manager.
		ui = { border = "double" }
	}
)

-- Options
-- We have to enable `termguicolors` for certain colorschemes to work correctly
vim.opt.termguicolors = true

-- Choose the colorscheme (overall, and for airline)
vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = "bubblegum"

vim.g.airline_left_sep = ''
vim.g.airline_left_alt_sep = ''
vim.g.airline_right_sep = ''
vim.g.airline_right_alt_sep = ''
vim.g.airline_symbols.branch = ''
vim.g.airline_symbols.readonly = ''
vim.g.airline_symbols.linenr = ''


vim.cmd.colorscheme("jellybeans-nvim")

-- No tabs, please
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Line numbers
vim.opt.number = true


-- Keymappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)  -- Show explorer
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy)  -- Show Lazy manager

