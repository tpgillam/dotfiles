return {
	"rockyzhang24/arctic.nvim",
	branch = "v2",
	dependencies = { "rktjmp/lush.nvim" },
	config = function ()
		-- Set the colorscheme. We also need to have termguicolors set.
		vim.cmd.set("termguicolors")
		vim.cmd.colorscheme("arctic")
	end
}
