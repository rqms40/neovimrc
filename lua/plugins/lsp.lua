-- Native LSP (Neovim 0.11+) + Mason for installs
-- Config via vim.lsp.config / enable; mason-lspconfig auto-enables installed servers
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Same LSP keybindings as before
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if not client then
					return
				end

				-- Document highlight on CursorHold
				local supports_highlight = false
				if client.supports_method then
					supports_highlight = client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
				end

				if supports_highlight then
					local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- Inlay hints toggle (same key: <leader>th)
				local supports_inlay = false
				if client.supports_method then
					supports_inlay = client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)
				end
				if supports_inlay then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Advertise nvim-cmp completion capabilities to language servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Server-specific overrides (merged into nvim-lspconfig defaults via vim.lsp.config)
		local servers = {
			ts_ls = {},
			-- Ruff LSP: lint + import organize (format via conform)
			ruff = {},
			-- Type checking for Python (npm-based; works without python3-venv)
			pyright = {
				settings = {
					pyright = {
						-- Prefer ruff for organize imports
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							typeCheckingMode = "standard",
							autoImportCompletions = true,
						},
					},
				},
			},
			html = { filetypes = { "html", "twig", "hbs", "blade" } },
			cssls = {},
			tailwindcss = {},
			dockerls = {},
			sqlls = {},
			terraformls = {},
			jsonls = {},
			yamlls = {},
			gopls = {
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						usePlaceholders = true,
					},
				},
			},
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = { command = "clippy" },
						procMacro = { enable = true },
					},
				},
			},
			bashls = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
							},
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						format = { enable = false },
						telemetry = { enable = false },
					},
				},
			},
		}

		-- Apply capabilities + overrides before mason enables servers
		for server_name, server_opts in pairs(servers) do
			server_opts.capabilities =
				vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
			vim.lsp.config(server_name, server_opts)
		end

		-- Also give capabilities to any other server mason enables without overrides
		vim.lsp.config("*", { capabilities = capabilities })

		-- Mason auto-install: prefer packages that install cleanly via npm/github releases.
		-- ruff/gopls are still configured, but enabled from PATH (standalone ruff / system go).
		local mason_servers = {}
		for name, _ in pairs(servers) do
			if name ~= "ruff" and name ~= "gopls" then
				table.insert(mason_servers, name)
			end
		end

		local ensure_installed = vim.deepcopy(mason_servers)
		vim.list_extend(ensure_installed, {
			"stylua",
			"prettier",
			"shfmt",
			"eslint_d",
			"checkmake",
		})

		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
		})

		require("mason-lspconfig").setup({
			ensure_installed = mason_servers,
			automatic_enable = true,
		})

		-- Enable PATH-installed tools (standalone ruff binary, system gopls/rust-analyzer, etc.)
		if vim.fn.executable("ruff") == 1 then
			vim.lsp.enable("ruff")
		end
		if vim.fn.executable("gopls") == 1 then
			vim.lsp.enable("gopls")
		end
		if vim.fn.executable("rust-analyzer") == 1 then
			vim.lsp.enable("rust_analyzer")
		end
	end,
}
