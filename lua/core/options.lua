-- General Neovim options
-- See :help option-list

vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

-- Sync clipboard with system
vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Faster completion and CursorHold
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Better split defaults
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Confirm before closing unsaved buffers
vim.opt.confirm = true

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor already set via scrolloff
vim.opt.fillchars = { eob = " " }
