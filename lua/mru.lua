local M = {}

---@type boolean enable or disable cache
local enable_cache = true
---@type table ignore path regexs
local ignore_path_regexs = {}
local mru_cache_file = vim.fn.stdpath('data') .. '/nvim-mru.json'
local files = {}
local log
local sort_by = 'lastenter'
local mru_backup_file = vim.fn.stdpath('data') .. '/nvim-mru-backup.json'

local max_usage_count = 5

local mru_time_range = 2 * 7 * 24 * 60 * 60 -- 2 weeks

local min_time_diff = 5 -- 5s

local unify_path = require('mru.utils').unify_path

local function is_ignore_path(p)
  for _, regex in ipairs(ignore_path_regexs) do
    if vim.regex(regex):match_str(p) then
      return true
    end
  end
  return false
end

local function read_cache(fname)
  local file = io.open(fname or mru_cache_file, 'r')
  if file then
    local context = file:read('*a')
    io.close(file)
    local obj = vim.json.decode(context)
    local keys = vim.tbl_filter(function(t)
      if is_ignore_path(t) then
        return false
      end
      if vim.fn.filereadable(t) == 0 then
        return false
      end
      if
        os.time()
          - math.max(
            obj[t].lastenter or 0,
            obj[t].lastmod or 0,
            obj[t].lastread or 0
          )
        > mru_time_range
      then
        return false
      end
      return true
    end, vim.tbl_keys(obj))
    files = {}
    for _, k in ipairs(keys) do
      files[k] = obj[k]
    end
  end
end

function M.calculate_frecentcy(f)
  local file = files[f]
  if not file then
    return 0
  end
  local frequency_weight = 0.7
  local recency_weight = 0.3

  local current_time = os.time()

  local time_diff = current_time - file.lastenter
  local lambda = 0.01

  local time_decay_factor = 1 / (1 + lambda * time_diff)

  local frecentcy = ((file.frecency or 0) * frequency_weight)
    + (time_decay_factor * recency_weight)
  return frecentcy
end

local function write_cache(fname)
  if not enable_cache then
    return
  end
  local file = io.open(fname or mru_cache_file, 'w')
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
---@field sort_by? string sort by `lastmod` or `lastenter`
---@field mru_backup_file? string path of backup file.

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
  if opt.mru_backup_file then
    mru_backup_file = opt.mru_backup_file
  end
  if opt.ignore_path_regexs then
    ignore_path_regexs = opt.ignore_path_regexs
  end
  if opt.enable_logger then
    log = require('mru.logger')
  end

  if
    opt.sort_by == 'lastmod'
    or opt.sort_by == 'lastenter'
    or opt.sort_by == 'lastread'
    or opt.sort_by == 'frecency' and sort_by ~= opt.sort_by
  then
    sort_by = opt.sort_by
  end

  read_cache()

  local create_autocmd = vim.api.nvim_create_autocmd
  create_autocmd({ 'BufRead' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(e)
      local f = unify_path(e.file)
      if vim.fn.filereadable(f) == 1 and not is_ignore_path(f) then
        if log then
          log.info('update lastread time of file:' .. f)
        end
        local frecency = 1
        if
          files[f]
          and files[f].frecency
          and math.min(
              os.time() - files[f].lastenter,
              os.time() - files[f].lastread
            )
            > min_time_diff
        then
          frecency = math.min(max_usage_count, frecency + files[f].frecency)
        end
        files[f] = {
          lastmod = vim.fn.getftime(f),
          lastenter = os.time(),
          lastread = os.time(),
          frecency = frecency,
        }
        write_cache()
      end
    end,
  })
  create_autocmd({ 'BufEnter' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(e)
      local f = unify_path(e.file)
      if vim.fn.filereadable(f) == 1 and not is_ignore_path(f) then
        if log then
          log.info('update lastenter time of file:' .. f)
        end
        if files[f] then
          if not files[f].lastmod then
            files[f].lastmod = vim.fn.getftime(f)
          end
          files[f].lastenter = os.time()
        else
          files[f] = {
            lastmod = vim.fn.getftime(f),
            lastenter = os.time(),
          }
        end
        if
          files[f]
          and files[f].frecency
          and math.min(
              os.time() - files[f].lastenter,
              os.time() - files[f].lastread
            )
            > min_time_diff
        then
          files[f].frecency = math.min(max_usage_count, 1 + files[f].frecency)
        end
        write_cache()
      end
    end,
  })
  create_autocmd({ 'BufWritePost' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(e)
      local f = unify_path(e.file)
      if vim.fn.filereadable(f) == 1 and not is_ignore_path(f) then
        if log then
          log.info('update lastmod time of file:' .. f)
        end
        if files[f] then
          files[f].lastmod = vim.fn.getftime(f)
        else
          files[f] = {
            lastmod = vim.fn.getftime(f),
            lastenter = os.time(),
          }
        end
        write_cache()
      end
    end,
  })
end

function M.get()
  local fs = vim.tbl_keys(files)
  if sort_by == 'lastmod' then
    table.sort(fs, function(a, b)
      return (files[a].lastmod or 0) > (files[b].lastmod or 0)
    end)
  elseif sort_by == 'lastread' then
    table.sort(fs, function(a, b)
      return (files[a].lastread or 0) > (files[b].lastread or 0)
    end)
  elseif sort_by == 'lastenter' then
    table.sort(fs, function(a, b)
      return (files[a].lastenter or 0) > (files[b].lastenter or 0)
    end)
  elseif sort_by == 'frecency' then
    table.sort(fs, function(a, b)
      return M.calculate_frecentcy(a) > M.calculate_frecentcy(b)
    end)
  end
  return fs
end

function M.clear()
  write_cache(mru_backup_file)
  files = {}
  write_cache()
end

function M.recover()
  read_cache(mru_backup_file)
  write_cache()
end

function M.remove(regex)
  local re = vim.regex(regex)
  for f, _ in pairs(files) do
    if re:match_str(f) then
      files[f] = nil
    end
  end
  write_cache()
end

return M
