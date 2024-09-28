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
        local moo = require("local_executables")
        local path_ruff = moo.find_executable_prefer_non_mason("ruff") or "ruff"
        require("lspconfig").ruff.setup {
            cmd = { path_ruff, "server" },
        }

        local path_pyright = moo.find_executable_prefer_non_mason("pyright-langserver") or "pyright-langserver"
        require("lspconfig").pyright.setup {
            cmd = { path_pyright, "--stdio" }
        }
        require("lspconfig").taplo.setup {
            -- Customisation to allow taplo to work outside of git repositories.
            --  See: https://www.reddit.com/r/neovim/comments/1fkprp5/how_to_properly_setup_lspconfig_for_toml_files/
            root_dir = require('lspconfig.util').root_pattern('*.toml', '.git')
        }
    end
}
