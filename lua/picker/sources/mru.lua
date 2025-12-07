local M = {}

local previewer = require('picker.previewer.file')

local get_icon

function M.set()
  local ok, devicon = pcall(require, 'nvim-web-devicons')
  if not ok then
    devicon = nil
  else
    get_icon = devicon.get_icon
  end
end

function M.get()
  return vim.tbl_map(function(t)
    if get_icon then
      local icon, hl = get_icon(vim.fn.fnamemodify(t, ':t'))
      return {
        value = t,
        str = (icon or '󰈔') .. ' ' .. t,
        highlight = {
          { 0, 2, hl },
        },
      }
    end
    return { value = t, str = t }
  end, require('mru').get())
end

function M.actions()
  return {
    ['<C-t>'] = function(entry)
      vim.cmd.tabedit(entry.value)
    end,
    ['<C-s>'] = function(entry)
      vim.cmd.split(entry.value)
    end,
    ['<C-v>'] = function(entry)
      vim.cmd.vsplit(entry.value)
    end,
  }
end

---@field item PickerItem
function M.default_action(item)
  vim.cmd('edit ' .. item.value)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
  previewer.preview(item.value, win, buf)
end

return M
