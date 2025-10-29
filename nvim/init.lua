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

-- Run the 'fix-all' ruff action if possible
local function lsp_ruff_fix_all()
    vim.lsp.buf.code_action({
        apply  = true,
        filter = function(action)
            return action.title:match("Fix all auto%-fixable problems")
        end,
    })
end

-- Options

-- We have to enable `termguicolors` for certain colorschemes to work correctly
vim.opt.termguicolors = true

-- Choose the colorscheme
vim.cmd.colorscheme("melange")

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
-- Snippet adapted from `:help zip` to register python ".whl" archives
-- to be viewed with the zip archive viewer.
vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = { "*.whl" },
    callback = function()
        vim.fn["zip#Browse"](vim.fn.expand("<amatch>"))
    end,
})

-- Show LSP diagnostics after the line (the default was changed to false in NeoVim 0.11)
vim.diagnostic.config({
    virtual_text = true,
})


-- Additional LSP configuration
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            -- Load the neovim API, to avoid 'undefined global' errors.
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            }
        }
    }
}
)
-- The options here will use `pyright` and `ruff` versions that are in the
-- project root; I'm happy to assume that I'll always be working in the context
-- of a uv-managed environment.
vim.lsp.config("ruff", {
    cmd = function(dispatchers, config)
        return vim.lsp.rpc.start(
            { "uv", "run", "ruff", "server" },
            dispatchers,
            { cwd = config.root_dir, env = config.cmd_env }
        )
    end,
})
vim.lsp.config("pyright", {
    cmd = function(dispatchers, config)
        return vim.lsp.rpc.start(
            { "uv", "run", "pyright-langserver", "--stdio" },
            dispatchers,
            { cwd = config.root_dir, env = config.cmd_env }
        )
    end,
})
-- They are also not managed by Mason, so enable them explicitly.
vim.lsp.enable("ruff")
vim.lsp.enable("pyright")
vim.lsp.enable("rust_analyzer")

-- Keymappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)  -- Show explorer
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy) -- Show Lazy manager

vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float { border = "rounded" } end)
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover { border = "rounded" } end)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<leader>c", vim.lsp.buf.rename)
-- NOTE: There are other LSP actions that we might want to map, e.g.
--  - lsp.buf.signature_help
--  - ...

-- Jump to the definition of the _type_ of the variable under the cursor.
vim.keymap.set("n", "<leader>D", require("telescope.builtin").lsp_type_definitions)

-- ruff fix all
vim.keymap.set("n", "<Leader>rf", lsp_ruff_fix_all)


vim.keymap.set("n", "<leader>rc", ":RuffCheck<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>py", ":Pyright<CR>", { noremap = true, silent = true })
