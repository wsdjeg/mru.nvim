-- test/example_spec.lua
-- Example test file demonstrating the testing pattern

local lu = require('luaunit')
local mru = require('mru')
local utils = require('mru.utils')

TestMruUtils = {}

function TestMruUtils:test_unify_path_basic()
  local result = utils.unify_path('/foo/bar/baz.txt')
  lu.assertEquals(type(result), 'string')
  lu.assertTrue(result:match('baz%.txt') ~= nil)
end

function TestMruUtils:test_unify_path_directory()
  local result = utils.unify_path('/foo/bar/')
  lu.assertTrue(string.sub(result, -1) == '/')
end

function TestMruUtils:test_unify_path_with_mod()
  local result = utils.unify_path('/foo/bar/baz.txt', ':t')
  lu.assertEquals(result, 'baz.txt')
end

TestMruModule = {}

function TestMruModule:test_require_returns_table()
  lu.assertEquals(type(mru), 'table')
end

function TestMruModule:test_exports_setup()
  lu.assertEquals(type(mru.setup), 'function')
end

function TestMruModule:test_exports_get()
  lu.assertEquals(type(mru.get), 'function')
end

function TestMruModule:test_exports_clear()
  lu.assertEquals(type(mru.clear), 'function')
end

function TestMruModule:test_exports_recover()
  lu.assertEquals(type(mru.recover), 'function')
end

function TestMruModule:test_exports_remove()
  lu.assertEquals(type(mru.remove), 'function')
end

function TestMruModule:test_get_returns_table()
  local result = mru.get()
  lu.assertEquals(type(result), 'table')
end

function TestMruModule:test_calculate_frecentcy_returns_number()
  local result = mru.calculate_frecentcy('nonexistent_file')
  lu.assertEquals(result, 0)
end

return TestMruUtils

