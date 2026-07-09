-- Treesitter main branch (rewrite; master is frozen)
-- Requires tree-sitter CLI >= 0.22 (`cargo install tree-sitter-cli`)
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		local parsers = {
			"bash",
			"c",
			"cmake",
			"css",
			"dockerfile",
			"gitignore",
			"go",
			"graphql",
			"groovy",
			"html",
			"java",
			"javascript",
			"json",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"regex",
			"sql",
			"terraform",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		}

		-- Install missing parsers asynchronously (no-op if already present)
		ts.install(parsers)

		-- Start highlighting for buffers with an available parser
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
			callback = function(event)
				local buf = event.buf
				local ft = vim.bo[buf].filetype
				if ft == "" then
					return
				end

				local lang = vim.treesitter.language.get_lang(ft) or ft
				local ok = pcall(vim.treesitter.start, buf, lang)
				if not ok then
					return
				end

				-- Indent via treesitter when the indent module is available
				local indent_ok, indent = pcall(function()
					return require("nvim-treesitter").indentexpr
				end)
				if indent_ok and type(indent) == "function" then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
