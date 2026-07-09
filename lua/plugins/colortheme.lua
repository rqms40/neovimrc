-- Catppuccin (mocha) — best-maintained pastel theme; transparent by default
-- Toggle solid/transparent with <leader>bg (same binding as before)
return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		local bg_transparent = true

		local function apply_catppuccin()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = bg_transparent,
				show_end_of_buffer = false,
				term_colors = true,
				dim_inactive = {
					enabled = false,
				},
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = false,
					treesitter = true,
					notify = false,
					mini = false,
					telescope = { enabled = true },
					which_key = true,
					indent_blankline = { enabled = true, scope_color = "lavender", colored_indent_levels = false },
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					mason = true,
					markdown = true,
				},
			})

			-- Prefer plugin scheme name (Neovim 0.12 may ship a builtin "catppuccin")
			local ok = pcall(vim.cmd.colorscheme, "catppuccin-mocha")
			if not ok then
				ok = pcall(vim.cmd.colorscheme, "catppuccin")
			end
			if not ok then
				vim.cmd.colorscheme("catppuccin-nvim")
			end
		end

		apply_catppuccin()

		-- Same keybinding as before: toggle transparent background
		vim.keymap.set("n", "<leader>bg", function()
			bg_transparent = not bg_transparent
			apply_catppuccin()
		end, { noremap = true, silent = true, desc = "Toggle background transparency" })
	end,
}
