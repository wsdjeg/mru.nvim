# mru.nvim

A lightweight Neovim plugin to manage and display your Most Recently Used (MRU) files.

<!-- vim-markdown-toc GFM -->

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [Self-Promotion](#self-promotion)
- [License](#license)

<!-- vim-markdown-toc -->

## Overview

`mru.nvim` keeps track of the files you’ve recently opened in Neovim and
provides quick access to them via telescope extension.

## Features

- Unified file path format.
- Ignore path via regex.
- Lightweight and no dependencies.

## Installation

Use your preferred Neovim plugin manager to install mru.nvim.

with [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
    { 'wsdjeg/mru.nvim' }
})
```

Then use `:PlugInstall mru.nvim` to install this plugin.

## Usage

Add custom keybindings to your init.lua for faster access. Example:

```lua
vim.api.nvim_set_keymap('n', '<leader>m', ':Telesscope mru<CR>', { noremap = true, silent = true })
```

Now, pressing `<leader>m` (e.g., `\m` by default) will open the MRU list.

Remove files from mru.

```lua
require('mru').remove(regex)
```

## Configuration

Customize mru.nvim by adding the following to your Neovim config:

```lua
require('mru').setup({
  enable_cache = true,
  mru_cache_file = vim.fn.stdpath('data') .. '/nvim-mru.json',
  events = { 'BufEnter', 'BufWritePost' }, -- events to update mru file list
  ignore_path_regexs = { '/.git/' },
  enable_logger = true, -- require wsdjeg/logger.nvim
})
```

## Contributing

Contributions are welcome! Feel free to:

- Fork this repository.
- Create a feature branch (git checkout -b feature/awesome-idea).
- Commit your changes (git commit -m "Add awesome idea").
- Push to the branch (git push origin feature/awesome-idea).
- Open a Pull Request.

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## License

This project is licensed under the GPL-3.0 License.
