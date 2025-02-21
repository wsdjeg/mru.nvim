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

after loading telescope.nvim, you need to load this extension:

```lua
require('telescope').load_extension('mru')
```
