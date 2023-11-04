require("lazy_bootstrap")

vim.g.mapleader = " "

-- Packages should be initialised _after_ remapping the <leader>
require("lazy").setup(
	"plugins",
	{
		ui = { border = "double" }
	}
)

-- Other keymapping changes

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)  -- Show explorer
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy)  -- Show Lazy manager

