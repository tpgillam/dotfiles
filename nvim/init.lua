require("lazy_bootstrap")

vim.g.mapleader = " "

-- Packages should be initialised _after_ remapping the <leader>
require("lazy").setup(
    "plugins", -- This will load all files in the `plugins` module.
    {
        -- Make it easier to see the edge of the Lazy plugin manager.
        ui = { border = "double" }
    }
)

-- Options

-- We have to enable `termguicolors` for certain colorschemes to work correctly
vim.opt.termguicolors = true

-- Choose the colorscheme
vim.cmd.colorscheme("nightfox")

-- No mouse support, please.
-- Among other things it hijacks selection - in WSL2 makes it impossible to
-- select and copy text into the windows buffer.
vim.opt.mouse = ""

-- No tabs, please
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Keymappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)                                        -- Show explorer
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy)                                       -- Show Lazy manager

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)                          -- See more about diagnostics
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end) -- Autoformat with LSP
vim.keymap.set("n", "gh", vim.lsp.buf.hover)                                         -- LSP hover action
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)                            -- LSP code action
vim.keymap.set("n", "gd", vim.lsp.buf.definition)                                    -- Go to definition
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)                                -- Go to implementation

-- NOTE: There are other LSP actions that we might want to map, e.g.
--  - lsp.buf.signature_help
--  - lsp.buf.rename
--  - ...
