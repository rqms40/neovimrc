-- In-buffer markdown rendering (toggle with <leader>mt)
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown", "md", "quarto" },
	opts = {
		-- Enabled by default when opening markdown; use <leader>mt to toggle
		enabled = true,
		render_modes = { "n", "c", "t" },
		heading = {
			enabled = true,
			sign = true,
			width = "full",
		},
		code = {
			enabled = true,
			sign = true,
			style = "full",
			border = "thin",
		},
		bullet = { enabled = true },
		checkbox = { enabled = true },
		quote = { enabled = true },
		pipe_table = { enabled = true, preset = "round" },
	},
	keys = {
		{
			"<leader>mt",
			function()
				require("render-markdown").toggle()
			end,
			desc = "Markdown render toggle",
		},
	},
}
