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


local function _quickfix(title, output)
    local lines = vim.tbl_map(vim.trim, vim.fn.split(output, '\n'))
    vim.fn.setqflist({}, 'r', { title = title, lines = lines })
    if #lines > 0 then
        vim.cmd('copen')
    else
        print(title .. ": all checks passed!")
    end
end

-- Integrate 'ruff check' with quickfix
local function run_ruff_check_quickfix()
    -- Using the -q option so that we only receive the errors
    local output = vim.fn.system('uv run ruff check -q')
    _quickfix('ruff check', output)
end

vim.api.nvim_create_user_command('RuffCheck', run_ruff_check_quickfix, {})

-- Integrate 'pyright' with quickfix
local function run_pyright_quickfix()
    -- Select only those lines of output that match '<line number>:<character number>',
    -- since pyright also includes "header" lines, one per file
    local output = vim.fn.system('uv run pyright | grep "[0-9]:[0-9]"')
    _quickfix('pyright', output)
end

vim.api.nvim_create_user_command('Pyright', run_pyright_quickfix, {})

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

-- Digraph remappings
vim.cmd("digraph </ 10216") -- ⟨
vim.cmd("digraph /> 10217") -- ⟩

-- Register filetypes for extensions
vim.filetype.add({
    pattern = {
        ['.*.jsonl'] = 'json',
    },
})

-- Keymappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)                                        -- Show explorer
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy)                                       -- Show Lazy manager

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)                          -- See more about diagnostics
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end) -- Autoformat with LSP
vim.keymap.set("n", "K", vim.lsp.buf.hover)                                          -- LSP hover action
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)                            -- LSP code action
vim.keymap.set("n", "gd", vim.lsp.buf.definition)                                    -- Go to definition
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)                                -- Go to implementation
vim.keymap.set("n", "<leader>c", vim.lsp.buf.rename)                                 -- Rename symbol

-- Jump to the definition of the _type_ of the variable under the cursor.
vim.keymap.set("n", "<leader>D", require("telescope.builtin").lsp_type_definitions)

-- NOTE: There are other LSP actions that we might want to map, e.g.
--  - lsp.buf.signature_help
--  - lsp.buf.rename
--  - ...

vim.keymap.set("n", "<leader>rc", ":RuffCheck<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>py", ":Pyright<CR>", { noremap = true, silent = true })
