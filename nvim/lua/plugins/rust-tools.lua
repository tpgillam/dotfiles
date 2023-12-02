return {
    "simrat39/rust-tools.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
        local rt = require("rust-tools")

        rt.setup({
            server = {
                on_attach = function(_, bufnr)
                    opts = { buffer = bufnr }
                    -- Hover actions
                    vim.keymap.set("n", "gh", rt.hover_actions.hover_actions, opts)
                    -- Code action groups
                    vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, opts)
                    vim.keymap.set("n", "<leader>do", rt.external_docs.open_external_docs, opts)

                    -- Make the inlay hints darker. By default the highlight is "Comment", which is
                    --  confusing.
                    rt.config.options.tools.inlay_hints.highlight = "Conceal"
                end,
            }
        })
    end
}
