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


-- Detect whether a command is available via `uv run`
local function _have_uv_run_command(command, root_dir)
    local res = vim.system(
        { "uv", "run", "which", "-s", command },
        { cwd = root_dir, text = true }
    ):wait()
    return res.code == 0
end

-- Return true iff the file at `path` is a PEP723 script
local function _is_pep723_script(path)
    -- If `uv tree` succeeds on the script, then it is pep723 compliant.
    -- Otherwise, it is not.
    local res = vim.system({ "uv", "tree", "--depth", "0", "--script", path }):wait()
    return res.code == 0
end

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
        local installed = _have_uv_run_command("ruff", config.root_dir)
        local cmd
        if installed then
            cmd = { "uv", "run", "ruff", "server" }
        else
            cmd = { "uvx", "ruff", "server" }
        end

        return vim.lsp.rpc.start(
            cmd,
            dispatchers,
            { cwd = config.root_dir, env = config.cmd_env }
        )
    end,
})
vim.lsp.config("pyright", {
    root_dir = function(bufnr, on_dir)
        -- Perform the 'default' lookup mechanism for `root_dir`.
        local root_tmp = vim.fs.root(bufnr, vim.lsp.config["ty"].root_markers)
        local ty_installed = _have_uv_run_command("ty", root_tmp);
        if not ty_installed then
            -- For now, run the pyright language server iff ty is not explicitly installed.
            -- NOTE: this logic is complementary to that in `ty` LS setup to ensure
            --  exactly one of the two is run.
            on_dir(root_tmp)
        end
    end,
    cmd = function(dispatchers, config)
        local path = vim.api.nvim_buf_get_name(0)
        local is_script = _is_pep723_script(path)
        local installed = _have_uv_run_command("pyright-langserver", config.root_dir)
        local cmd
        if installed then
            if is_script then
                cmd = { "uv", "run", "--with-requirements", path, "pyright-langserver", "--stdio" }
            else
                cmd = { "uv", "run", "pyright-langserver", "--stdio" }
            end
        else
            if is_script then
                cmd = { "uvx", "--with-requirements", path, "--from", "pyright[nodejs]", "pyright-langserver", "--stdio" }
            else
                -- We use 'run --with' so that we include the project's dependencies in the environment
                -- in which pyright runs. This is needed for it to perform analysis properly.
                cmd = { "uv", "run", "--with", "pyright[nodejs]", "pyright-langserver", "--stdio" }
            end
        end

        return vim.lsp.rpc.start(
            cmd,
            dispatchers,
            { cwd = config.root_dir, env = config.cmd_env }
        )
    end,
})
vim.lsp.config("ty", {
    root_dir = function(bufnr, on_dir)
        -- Perform the 'default' lookup mechanism for `root_dir`.
        local root_tmp = vim.fs.root(bufnr, vim.lsp.config["ty"].root_markers)
        local ty_installed = _have_uv_run_command("ty", root_tmp);
        if ty_installed then
            -- For now, run the ty language server iff ty is explicitly installed.
            -- NOTE: this logic is complementary to that in `pyright` LS setup to ensure
            --  exactly one of the two is run.
            on_dir(root_tmp)
        end
    end,
    cmd = function(dispatchers, config)
        return vim.lsp.rpc.start(
            { "uv", "run", "ty", "server" },
            dispatchers,
            { cwd = config.root_dir, env = config.cmd_env }
        )
    end,
})
vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            check = { command = "clippy" }
        }
    }
})

-- These LSPs are also not managed by Mason, so enable them explicitly.
vim.lsp.enable("ruff")
vim.lsp.enable("pyright")
vim.lsp.enable("ty")
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
