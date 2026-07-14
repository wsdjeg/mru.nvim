# mru.nvim

[![Run Tests](https://github.com/wsdjeg/mru.nvim/actions/workflows/test.yml/badge.svg)](https://github.com/wsdjeg/mru.nvim/actions/workflows/test.yml)
[![GitHub License](https://img.shields.io/github/license/wsdjeg/mru.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/mru.nvim)](https://github.com/wsdjeg/mru.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/mru.nvim)](https://github.com/wsdjeg/mru.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/mru.nvim)](https://github.com/wsdjeg/mru.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/mru.nvim)](https://luarocks.org/modules/wsdjeg/mru.nvim)

A lightweight Neovim plugin to manage and display your Most Recently Used (MRU) files.

<!-- vim-markdown-toc GFM -->

- [📘 Intro](#-intro)
- [❓ Why not v:oldfiles?](#-why-not-voldfiles)
- [✨ Features](#-features)
- [📦 Installation](#-installation)
- [🔧 Configuration](#-configuration)
- [⚙️ Basic Usage](#️-basic-usage)
    - [Commands](#commands)
    - [API](#api)
    - [Quickfix](#quickfix)
    - [Picker mru](#picker-mru)
    - [Telescope mru](#telescope-mru)
- [📣 Self-Promotion](#-self-promotion)
- [📄 License](#-license)

<!-- vim-markdown-toc -->

## 📘 Intro

`mru.nvim` keeps track of the files you've recently opened in Neovim and
provides quick access to them via quickfix, picker.nvim, or telescope.nvim extension.

## ❓ Why not v:oldfiles?

mru.nvim does not aim to replace `v:oldfiles` directly.
Instead, it maintains its own MRU tracking to address several practical limitations:

- **Unified path format**: `v:oldfiles` may contain inconsistent or duplicated paths on Windows.
- **Regex-based path filtering**: Exclude files or directories to avoid recording sensitive paths.
- **Editable and persistent**: The MRU list can be modified, and changes remain effective after restarting Neovim.
- **Fuzzy search support**: Integrates with picker.nvim or telescope.nvim for fuzzy searching recently edited files.
- **Flexible sorting strategies**: Sort by last enter time, read time, modified time, or frecency.

## ✨ Features

- **Unified file path format** - Consistent paths across platforms.
- **Regex-based path filtering** - Exclude sensitive or unwanted paths.
- **Lightweight and no dependencies** - Zero required dependencies.
- **Devicons support** - Optional integration with nvim-web-devicons.
- **Flexible sorting** - Sort by `lastenter`, `lastread`, `lastmod`, or `frecency`.
- **Persistent cache** - MRU list survives Neovim restarts.
- **Backup and recover** - Clear and restore your MRU list anytime.

## 📦 Installation

Use your preferred Neovim plugin manager to install mru.nvim.

Using [nvim-plug](https://github.com/wsdjeg/nvim-plug):

```lua
require('plug').add({
  { 'wsdjeg/mru.nvim' }
})
```

Then use `:PlugInstall mru.nvim` to install this plugin.

Using [LuaRocks](https://luarocks.org/):

```sh
luarocks install mru.nvim
```

## 🔧 Configuration

The following is the default option of mru.nvim.

```lua
require('mru').setup({
  -- enable or disable cache (default: true)
  enable_cache = true,
  -- cache file path (default: stdpath('data') .. '/nvim-mru.json')
  mru_cache_file = vim.fn.stdpath('data') .. '/nvim-mru.json',
  -- backup file path (default: stdpath('data') .. '/nvim-mru-backup.json')
  mru_backup_file = vim.fn.stdpath('data') .. '/nvim-mru-backup.json',
  -- table of regex to ignore paths (default: {})
  ignore_path_regexs = { '/.git/' },
  -- enable logger.nvim (default: false, requires wsdjeg/logger.nvim)
  enable_logger = false,
  -- sort strategy: `lastenter`, `lastread`, `lastmod`, or `frecency`
  -- default: `lastenter`
  sort_by = 'lastenter',
})
```

## ⚙️ Basic Usage

### Commands

| Command            | Description                                    |
| ------------------ | ---------------------------------------------- |
| `:Mru`             | List MRU files in the quickfix window          |
| `:Mru remove {re}` | Remove files matching regex from the MRU list  |

### API

| Function                           | Description                                  |
| ---------------------------------- | -------------------------------------------- |
| `require('mru').setup(opt)`        | Initialize the plugin with options           |
| `require('mru').get()`             | Returns a sorted list of MRU file paths      |
| `require('mru').clear()`           | Backup current list to backup file, then clear |
| `require('mru').recover()`         | Restore MRU list from backup file            |
| `require('mru').remove(regex)`     | Remove files matching regex from MRU list    |
| `require('mru').calculate_frecentcy(f)` | Calculate frecency score for a file     |

### Quickfix

Run `:Mru` to list all MRU files in the quickfix window:

```vim
:Mru
```

Remove files matching a regex pattern:

```vim
:Mru remove \.tmp$
```

Or via Lua API:

```lua
require('mru').remove('\\.tmp$')
```

### Picker mru

mru.nvim provides a source for [picker.nvim](https://github.com/wsdjeg/picker.nvim),
which can be opened via `:Picker mru`.

Key bindings for picker mru extension:

| Key Binding | Description                            |
| ----------- | -------------------------------------- |
| `<Enter>`   | Open file in the current window        |
| `<C-s>`     | Open file in a horizontal split window |
| `<C-v>`     | Open file in a vertical split window   |
| `<C-t>`     | Open file in a new tab                 |

```lua
vim.api.nvim_set_keymap('n', '<leader>m', ':Picker mru<CR>', { noremap = true, silent = true })
```

### Telescope mru

mru.nvim also provides a [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) extension:

```lua
vim.api.nvim_set_keymap('n', '<leader>m', ':Telescope mru<CR>', { noremap = true, silent = true })
```

Now, pressing `<leader>m` (e.g., `\m` by default) will open the MRU list.

## 📣 Self-Promotion

Like this plugin? Star the repository on
[GitHub](https://github.com/wsdjeg/mru.nvim).

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## 📄 License

This project is licensed under the GPL-3.0 License.

