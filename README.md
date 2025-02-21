# mru.nvim

## setup

```lua
require('mru').setup({
    -- options
})
```

default options:

```lua
{
    enable_cache = true,
    mru_cache_file = vim.fn.stdpath('data') .. '/nvim-mru.json'
}
```

## Usage

get mru:

```
require('mru').get()
```

clear mru:

```
require('mru').clear()
```

## Telescope source

This plugin also provide a telescope source: `:Telescope mru`
