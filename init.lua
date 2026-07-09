require("core.options") -- Load general options
require("core.keymaps") -- Load general keymaps
require("core.snippets") -- Diagnostics, yank highlight, shared UX

-- Prefer user-local toolchains (cargo tree-sitter CLI, standalone ruff, etc.)
for _, dir in ipairs({
	vim.fn.expand("~/.cargo/bin"),
	vim.fn.expand("~/.local/bin"),
}) do
	if vim.fn.isdirectory(dir) == 1 then
		vim.env.PATH = dir .. ":" .. (vim.env.PATH or "")
	end
end

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require("lazy").setup({
	require("plugins.colortheme"),
	require("plugins.treesitter"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.autocompletion"),
	require("plugins.formatting"),
	require("plugins.linting"),
	require("plugins.gitsigns"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.comment"),
	require("plugins.vimbegood"),
	require("plugins.harpoon"),
	require("plugins.undotree"),
	require("plugins.oil"),
	require("plugins.trouble"),
}, {
	ui = {
		border = "rounded",
	},
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
