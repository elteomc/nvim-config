return {
    -- toggleterm was already installed, so I just configured a Julia terminal
    {
        "akinsho/toggleterm.nvim",
        optional = true,
        opts = function(_, opts)
            opts.shell = opts.shell
        end,
    }
}
