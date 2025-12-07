# mru.nvim

A lightweight Neovim plugin to manage and display your Most Recently Used (MRU) files.

[![GitHub License](https://img.shields.io/github/license/wsdjeg/mru.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/mru.nvim)](https://github.com/wsdjeg/mru.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/mru.nvim)](https://github.com/wsdjeg/mru.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/mru.nvim)](https://github.com/wsdjeg/mru.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/mru.nvim)](https://luarocks.org/modules/wsdjeg/mru.nvim)

<!-- vim-markdown-toc GFM -->

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
    - [Picker mru](#picker-mru)
    - [Telescope mru](#telescope-mru)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [Credits](#credits)
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
- Support nvim-web-devicons

## Installation

Use your preferred Neovim plugin manager to install mru.nvim.

Using [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
    { 'wsdjeg/mru.nvim' }
})
```

Then use `:PlugInstall mru.nvim` to install this plugin.

Using [luarocks](https://luarocks.org/)

```
luarocks install mru.nvim
```

## Usage

This plugin provides a `:Mru` command, which will list mru files in quickfix windows.

Users also can use fuzzy finder plugin. mru.nvim provides telescope extension and picker.nvim extension.

Add custom keybindings to your init.lua for faster access. Example:

### Picker mru

mru.nvim also provides a mru source for picker.nvim. which can be opened via `:Picker mru`.

key bindings for picker mru extension:

| Key Binding | Description                            |
| ----------- | -------------------------------------- |
| `<Enter>`   | open file in the current window        |
| `<C-s>`     | open file in a horizontal split window |
| `<C-v>`     | open file in a vertical split window   |
| `<C-t>`     | open file in a new tab                 |

```lua
vim.api.nvim_set_keymap('n', '<leader>m', ':Picker mru<CR>', { noremap = true, silent = true })
```

### Telescope mru

```lua
vim.api.nvim_set_keymap('n', '<leader>m', ':Telescope mru<CR>', { noremap = true, silent = true })
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
  ignore_path_regexs = { '/.git/' },
  enable_logger = true, -- require wsdjeg/logger.nvim
  -- sort file by last modified time or last enter time
  -- `lastmod`, `lastread`, `frecency`
  -- or `lastenter`, default is `lastenter`
  sort_by = 'lastenter',
})
```

## Contributing

Contributions are welcome! Feel free to:

- Fork this repository.
- Create a feature branch (git checkout -b feature/awesome-idea).
- Commit your changes (git commit -m "Add awesome idea").
- Push to the branch (git push origin feature/awesome-idea).
- Open a Pull Request.

## Credits

- [Shougo/neomru.vim](https://github.com/Shougo/neomru.vim)

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## License

This project is licensed under the GPL-3.0 License.
