vim.api.nvim_create_user_command('Mru', function(opt)
  if #opt.fargs == 0 then
    local mrus = vim.tbl_map(function(t)
      return {
        filename = t,
      }
    end, require('mru').get())
    vim.fn.setqflist({}, 'r', { title = 'Mru files', items = mrus })
    vim.cmd.copen()
  elseif #opt.fargs >= 2 and opt.fargs[1] == 'remove' then
    require('mru').remove(opt.fargs[2])
  end
end, {
  nargs = '*',
  complete = function()
    return { 'remove' }
  end,
})
