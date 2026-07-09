-- Async linting via nvim-lint (modern none-ls replacement for diagnostics)
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile", "BufWritePost" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			make = { "checkmake" },
			-- Python linting is handled by the ruff LSP (see plugins/lsp.lua)
		}

		local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Avoid noisy errors when a linter binary is missing for a filetype
				if vim.bo.modifiable then
					lint.try_lint()
				end
			end,
		})
	end,
}
