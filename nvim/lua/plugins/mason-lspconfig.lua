-- Determine the path separator (':' on Unix, ';' on Windows)
local function _get_pathsep()
    if package.config:sub(1, 1) == '\\' then
        return ';'
    else
        return ':'
    end
end

-- Function to construct and verify the absolute path
local function _get_executable_path(dir, name)
    local full_path = vim.fn.join({ dir, name }, "/")

    if vim.fn.executable(full_path) == 1 then
        return vim.fn.fnamemodify(full_path, ":p")
    end
    return nil
end

local function _find_executable_prefer_non_mason(executable)
    local path_separator = _get_pathsep()
    local path_components = vim.split(vim.env.PATH, path_separator, { plain = true })
    local non_mason_paths = {}
    local mason_paths = {}

    for _, component in ipairs(path_components) do
        if component:find(".local/share/nvim/mason") then
            table.insert(mason_paths, component)
        else
            table.insert(non_mason_paths, component)
        end
    end

    -- Search non-mason paths first
    for _, path in ipairs(non_mason_paths) do
        local exec_path = _get_executable_path(path, executable)
        if exec_path then
            return exec_path
        end
    end

    -- If not found, search mason paths
    for _, path in ipairs(mason_paths) do
        local exec_path = _get_executable_path(path, executable)
        if exec_path then
            return exec_path
        end
    end

    -- If not found anywhere, return nil
    return nil
end


return {
    "williamboman/mason-lspconfig",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
        -- Here we ensure that specific plugins that we need are installed.
        -- NOTE: we specify the plugins by LSP name, _not_ package name.
        --  e.g. the "julia-lsp" package provides the "julials" language server.
        require("mason-lspconfig").setup {
            ensure_installed = {
                "julials",
                "lua_ls",
                "ruff",
                "pyright",
                "taplo"
            }
        }

        -- Now we can set up the language servers we want...
        require("lspconfig").julials.setup {}
        require("lspconfig").lua_ls.setup {
            settings = {
                Lua = {
                    -- Load the neovim API, to avoid 'undefined global' errors.
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('lua', true),
                    },
                    telemetry = {
                        enable = false,
                    }
                }
            }
        }

        -- The options here will use `python` and `ruff` versions that are on the
        -- current PATH; but ideally not in vim's "mason" directory. I am
        -- generally assuming that I'll be running vim in the context of a
        -- virtualenv anyway, since this is required for pyright to work
        -- properly.
        local path_python = _find_executable_prefer_non_mason("python") or "python"
        local path_ruff = _find_executable_prefer_non_mason("ruff") or "ruff"
        require("lspconfig").ruff.setup {
            init_options = {
                settings = {
                    interpreter = { path_python },
                    path = { path_ruff }
                }
            }
        }

        local path_pyright = _find_executable_prefer_non_mason("pyright-langserver") or "pyright-langserver"
        require("lspconfig").pyright.setup {
            cmd = { path_pyright, "--stdio" }
        }
        require("lspconfig").taplo.setup {}
    end
}
