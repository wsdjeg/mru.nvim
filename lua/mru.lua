local M = {}

local enable_cache = true
local mru_cache_file = vim.fn.stdpath('data') .. '/nvim-mru.json'
local files = {}
local function read_cache()
  local file = io.open(mru_cache_file, 'r')
  if file then
    local context = file:read('*a')
    io.close(file)
    files = vim.json.decode(context)
  end
end

local unify_path = require('mru.utils').unify_path

read_cache()

local function write_cache()
  if not enable_cache then
    return
  end
  local file = io.open(mru_cache_file, 'w')
  if file then
    file:write(vim.json.encode(files))
    io.close(file)
  end
end

function M.setup(opt)
  opt = opt or {}
  local augroup = vim.api.nvim_create_augroup('mru.nvim', { clear = true })
  if opt.enable_cache == false then
    enable_cache = false
  end
  if opt.mru_cache_file then
    mru_cache_file = opt.mru_cache_file
  end

  local create_autocmd = vim.api.nvim_create_autocmd
  create_autocmd(opt.events or { 'BufEnter', 'BufWritePost' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(e)
      local f = unify_path(e.file)
      if vim.fn.filereadable(f) == 1 then
        files[f] = vim.uv.gettimeofday()
        write_cache()
      end
    end,
  })
end

function M.get()
  local fs = vim.tbl_keys(files)
  table.sort(fs, function(a, b)
    return files[a] > files[b]
  end)
  return fs
end

function M.clear()
  files = {}
  write_cache()
end

return M
