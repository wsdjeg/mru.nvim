local M = {}
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

read_cache()

local function write_cache()
  local file = io.open(mru_cache_file, 'w')
  if file then
    file:write(vim.json.encode(files))
    io.close(file)
  end
end

function M.setup(opt)
  local augroup = vim.api.nvim_create_augroup('mru.nvim', { clear = true })

  local create_autocmd = vim.api.nvim_create_autocmd
  create_autocmd({ 'BufRead' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(e)
      local f = vim.fs.normalize(e.file)
      if not vim.tbl_contains(files, f) then
        table.insert(files, f)
      end
      if opt.enable_cache then
        write_cache()
      end
    end,
  })
end

function M.get()
  return files
end

return M
