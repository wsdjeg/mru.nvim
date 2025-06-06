local M = {}

local enable_cache = true
local ignore_path_regexs = {}
local mru_cache_file = vim.fn.stdpath('data') .. '/nvim-mru.json'
local files = {}
local log

local unify_path = require('mru.utils').unify_path

local function is_ignore_path(p)
  for _, regex in ipairs(ignore_path_regexs) do
    if vim.regex(regex):match_str(p) then
      return true
    end
  end
  return false
end
local function read_cache()
  local file = io.open(mru_cache_file, 'r')
  if file then
    local context = file:read('*a')
    io.close(file)
    local obj = vim.json.decode(context)
    local keys = vim.tbl_filter(function(t)
      return vim.fn.filereadable(t) == 1 and not is_ignore_path(t)
    end, vim.tbl_keys(obj))
    files = {}
    for _, k in ipairs(keys) do
      files[k] = obj[k]
    end
  end
end

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

---@class MruSetupOpt
---@field enable_cache? boolean enable or disable cache.
---@field mru_cache_file? string specific the cache file path.
---@field ignore_path_regexs? string[] table of regex
---@field enable_logger? boolean enable or disable logger.nvim


---@param opt MruSetupOpt
function M.setup(opt)
  opt = opt or {}
  local augroup = vim.api.nvim_create_augroup('mru.nvim', { clear = true })
  if opt.enable_cache == false then
    enable_cache = false
  end
  if opt.mru_cache_file then
    mru_cache_file = opt.mru_cache_file
  end
  if opt.ignore_path_regexs then
    ignore_path_regexs = opt.ignore_path_regexs
  end
  if opt.enable_logger then
    log = require('mru.logger')
  end

  read_cache()

  local create_autocmd = vim.api.nvim_create_autocmd
  create_autocmd(opt.events or { 'BufEnter', 'BufWritePost' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(e)
      local f = unify_path(e.file)
      if vim.fn.filereadable(f) == 1 and not is_ignore_path(f) then
        if log then
          log.info('update time of file:' .. f)
        end
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
