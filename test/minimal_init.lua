-- test/minimal_init.lua
-- Minimal Neovim configuration for testing

print('Initializing test environment...')

-- Set up essential settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false
vim.opt.verbose = 1

-- Set up package path for:
-- 1. lua/?.lua - Main plugin source code
-- 2. test/?.lua - Mock modules
-- 3. test/.deps/?.lua - Test dependencies (luaunit)
package.path = 'lua/?.lua;test/?.lua;test/.deps/?.lua;' .. package.path
vim.opt.runtimepath:prepend('.')

-- Create temporary test directory for cache files
local test_dir = vim.fn.tempname() .. '_mru_nvim_test'
vim.fn.mkdir(test_dir, 'p')

-- Store test directory globally so tests can access it
_G.MRU_TEST_DIR = test_dir

-- Load plugin with test configuration
local ok, err = pcall(function()
  require('mru').setup({
    enable_cache = true,
    mru_cache_file = test_dir .. '/nvim-mru.json',
    mru_backup_file = test_dir .. '/nvim-mru-backup.json',
    ignore_path_regexs = { '/.git/' },
    sort_by = 'lastenter',
  })
end)

if not ok then
  print('Error initializing test environment: ' .. err)
else
  print('Test environment initialized successfully')
  print('Test directory: ' .. test_dir)
end

