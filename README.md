# mru.nvim

A lightweight Neovim plugin to manage and display your Most Recently Used (MRU) files.

## Overview

`mru.nvim` keeps track of the files you’ve recently opened in Neovim and provides quick access to them via telescope exten.
Perfect for developers, writers, or anyone who wants to streamline their workflow in Neovim.

## Features

- Unify file path.
- Easy navigation and file selection.
- Lightweight and minimal dependencies.
- Configurable options to suit your needs.

## Installation

Use your preferred Neovim plugin manager to install mru.nvim.

with nvim-plug

```lua
require('plug').add({
    { 'wsdjeg/mru.nvim' }
})
```

After installation, run `:PlugInstall` (depending on your plugin manager) to fetch the plugin.

## Usage

Add custom keybindings to your init.lua or init.vim for faster access. Example:

```lua
vim.api.nvim_set_keymap('n', '<leader>m', ':Telesscope mru<CR>', { noremap = true, silent = true })
```

Now, pressing `<leader>m` (e.g., `\m` by default) will open the MRU list.

## Configuration

Customize mru.nvim by adding the following to your Neovim config (e.g., init.lua):

```lua
require('mru').setup({
    enable_cache = true,
    mru_cache_file = vim.fn.stdpath('data') .. '/nvim-mru.json'
})
```

## Contributing

Contributions are welcome! Feel free to:

- Fork this repository.
- Create a feature branch (git checkout -b feature/awesome-idea).
- Commit your changes (git commit -m "Add awesome idea").
- Push to the branch (git push origin feature/awesome-idea).
- Open a Pull Request.

## License

This project is licensed under the GPL-3.0 License.
