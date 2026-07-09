# neovimrc

Personal Neovim config.

## Setup

```bash
./dev
```

This symlinks the repo to `~/.config/nvim`.

Requires Neovim 0.11+ (0.12 recommended).

## Notes

- Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)
- Theme: Catppuccin mocha (transparent by default; toggle with `<leader>bg`)
- LSP via Mason + native `vim.lsp`
- Format on save: conform.nvim
- Lint: nvim-lint
