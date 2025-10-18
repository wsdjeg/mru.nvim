local M = {}

local previewer = require("picker.previewer.file")

function M.get()
	return vim.tbl_map(function(t)
		return { value = t, str = t }
	end, require("mru").get())
end

---@field item PickerItem
function M.default_action(item)
	vim.cmd("edit " .. item.value)
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
	previewer.preview(item.value, win, buf)
end

return M

