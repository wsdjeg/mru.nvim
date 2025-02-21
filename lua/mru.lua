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
  create_autocmd({ 'BufRead' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(e)
      local f = unify_path(e.file)
      if not vim.tbl_contains(files, f) then
        table.insert(files, f)
      end
      write_cache()
    end,
  })
end

function M.get()
  return files
end

function M.clear()
  files = {}
  write_cache()
end

return M
