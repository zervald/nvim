-- Run with: nvim --headless -u NONE -l tests/ionodes.lua
package.path = './lua/?.lua;' .. package.path

local root = vim.fn.tempname() .. ' ionodes'
local original_cwd = vim.fn.getcwd()
local original_path = vim.env.PATH
local original_select, original_input, original_notify = vim.ui.select, vim.ui.input, vim.notify
local messages = {}
local finished = false
local choices = {}
local seen_modules, seen_families

local function write(path, lines)
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  vim.fn.writefile(lines, path)
end

write(root .. '/build.sh', {
  '#!/usr/bin/env bash',
  'printf "%s\\n" "$*" >> build.log',
  'exit "${IONODES_TEST_EXIT:-0}"',
})
write(root .. '/bin/bear', {
  '#!/usr/bin/env bash',
  'output=$2',
  'shift 3',
  '"$@" || exit $?',
  'printf "%s" "${IONODES_TEST_DATABASE:-[]}" > "$output"',
})
write(root .. '/bin/launchpad', {
  '#!/usr/bin/env bash',
  'printf "%s\\n" "$PWD" "$@" > import.log',
  'exit "${IONODES_TEST_EXIT:-0}"',
})
vim.fn.setfperm(root .. '/bin/launchpad', 'rwxr-xr-x')
vim.fn.setfperm(root .. '/bin/bear', 'rwxr-xr-x')
write(root .. '/Makefile', {})
write(root .. '/Module with spaces/Makefile', {})
write(root .. '/.git/ignored/Makefile', {})
write(root .. '/Module with spaces/target.build/Makefile', {})
write(root .. '/Build/linux/family/board_families.mk', {})
write(root .. '/Build/linux/family/atomas_im.mk', {})
write(root .. '/Build/linux/target/qcs610.mk', {})
write(root .. '/sdk env.sh', { 'export IONODES_TEST_DATABASE=\'[{"file":"sample.cpp","directory":"/tmp","arguments":["g++","sample.cpp"]}]\'' })
vim.env.PATH = root .. '/bin:' .. original_path
vim.api.nvim_set_current_dir(root)

vim.ui.select = function(items, opts, callback)
  if opts.prompt == 'Module to compile' then
    seen_modules = items
  elseif opts.prompt == 'Board family' then
    seen_families = items
  end
  local choice = table.remove(choices, 1)
  if choice == 'CANCEL' then
    callback(nil)
  else
    assert(vim.list_contains(items, choice), 'Unexpected selection: ' .. tostring(choice))
    callback(choice)
  end
end
local sdk_path = root .. '/sdk env.sh'
vim.ui.input = function(opts, callback)
  if opts.completion == 'file' then
    callback(sdk_path)
    return
  end
  assert(opts.completion == "customlist,v:lua.require'config.ionodes'.complete")
  local items = require('config.ionodes').complete ''
  if opts.prompt == 'Module to compile: ' then
    seen_modules = items
    write(root .. '/NewModule/Makefile', {})
    assert(vim.deep_equal(require('config.ionodes').complete 'New', { 'NewModule' }))
    vim.fn.delete(root .. '/NewModule/Makefile')
    assert(#require('config.ionodes').complete 'New' == 0)
  elseif opts.prompt == 'Board family: ' then
    seen_families = items
  elseif opts.prompt == 'Target toolchain: ' then
    write(root .. '/Build/linux/target/new-target.mk', {})
    assert(vim.deep_equal(require('config.ionodes').complete 'new', { 'new-target' }))
    vim.fn.delete(root .. '/Build/linux/target/new-target.mk')
  end
  local choice = table.remove(choices, 1)
  if choice == 'CANCEL' then
    callback(nil)
  else
    assert(vim.list_contains(items, choice), 'Unexpected input: ' .. tostring(choice))
    callback(choice)
  end
end
vim.notify = function(message)
  messages[#messages + 1] = message
  finished = true
end

local cpp = require('config.ionodes').cpp
local function run(clean, target)
  finished = false
  choices = { 'Module with spaces', 'atomas_im', target or 'qcs610', 'Debug', clean, 'Run' }
  cpp()
  assert(
    vim.wait(10000, function()
      return finished
    end),
    'Capture timed out'
  )
end

local function tests()
  run 'Clean selected module first'
  assert(vim.deep_equal(seen_modules, { 'Module with spaces' }), vim.inspect(seen_modules))
  assert(vim.deep_equal(seen_families, { 'atomas_im' }))
  local database = table.concat(vim.fn.readfile(root .. '/compile_commands.json'))
  assert(#vim.json.decode(database) == 1)
  local log = vim.fn.readfile(root .. '/build.log')
  assert(#log == 2 and log[1]:match '%-c$' and not log[2]:match '%-c$')
  assert(log[2] == '-m Module with spaces -b atomas_im -t qcs610 -d')

  run('Incremental', 'Board default')
  log = vim.fn.readfile(root .. '/build.log')
  assert(#log == 3 and log[3] == '-m Module with spaces -b atomas_im -d')

  vim.env.IONODES_TEST_EXIT = '7'
  run 'Incremental'
  assert(messages[#messages]:find('exit 7', 1, true))
  assert(table.concat(vim.fn.readfile(root .. '/compile_commands.json')) == database)
  vim.env.IONODES_TEST_EXIT = nil

  sdk_path = ''
  vim.env.IONODES_TEST_DATABASE = '[]'
  run 'Incremental'
  assert(messages[#messages]:find('no valid compilation entries', 1, true))
  assert(table.concat(vim.fn.readfile(root .. '/compile_commands.json')) == database)
  vim.env.IONODES_TEST_DATABASE = 'invalid json'
  run 'Incremental'
  assert(messages[#messages]:find('no valid compilation entries', 1, true))
  assert(table.concat(vim.fn.readfile(root .. '/compile_commands.json')) == database)

  local before = #vim.fn.readfile(root .. '/build.log')
  choices = { 'CANCEL' }
  cpp()
  assert(#vim.fn.readfile(root .. '/build.log') == before)
  assert(#vim.fn.glob(root .. '/.ionodes-compile-*.json', false, true) == 0)
  assert(#require('config.ionodes').complete '' == 0)

  write(root .. '/Import/Selected file.txt', {})
  write(root .. '/Import/nested/Hidden.txt', {})
  write(root .. '/Import/ignored.md', {})
  local import = require('config.ionodes').import
  local selected = 'Selected file.txt'
  vim.ui.input = function(opts, callback)
    assert(opts.prompt == 'Import file: ')
    assert(vim.deep_equal(require('config.ionodes').complete '', { 'Selected file.txt' }))
    write(root .. '/Import/New.txt', {})
    assert(vim.deep_equal(require('config.ionodes').complete 'N', { 'New.txt' }))
    vim.fn.delete(root .. '/Import/New.txt')
    assert(#require('config.ionodes').complete 'N' == 0)
    callback(selected)
  end
  local function run_import()
    finished = false
    import()
    assert(
      vim.wait(10000, function()
        return finished
      end),
      'Import timed out'
    )
  end
  run_import()
  assert(vim.deep_equal(vim.fn.readfile(root .. '/import.log'), {
    root,
    'import',
    root .. '/Import/Selected file.txt',
  }))
  assert(messages[#messages]:find('completed', 1, true))
  vim.env.IONODES_TEST_EXIT = '3'
  run_import()
  assert(messages[#messages]:find('exit 3', 1, true))
  vim.env.IONODES_TEST_EXIT = nil
  vim.fn.delete(root .. '/import.log')
  selected = '../outside.txt'
  run_import()
  assert(messages[#messages]:find('Invalid import file', 1, true))
  assert(vim.fn.filereadable(root .. '/import.log') == 0)
  selected = nil
  import()
  assert(#require('config.ionodes').complete '' == 0)
  assert(vim.fn.filereadable(root .. '/import.log') == 0)

  vim.api.nvim_set_current_dir(original_cwd)
  vim.ui.input = function()
    error 'No prompts expected outside the Ionodes repository'
  end
  vim.ui.select = vim.ui.input
  cpp()
  assert(messages[#messages] == 'Not in an Ionodes repository.')
  assert(#require('config.ionodes').complete '' == 0)
  import()
  assert(messages[#messages] == 'Not in a repository with an Import directory.')
end

local ok, err = xpcall(tests, debug.traceback)
vim.ui.select, vim.ui.input, vim.notify = original_select, original_input, original_notify
vim.env.PATH = original_path
vim.env.IONODES_TEST_EXIT = nil
vim.env.IONODES_TEST_DATABASE = nil
vim.api.nvim_set_current_dir(original_cwd)
vim.fn.delete(root, 'rf')
if not ok then
  error(err)
end
print 'Ionodes capture tests passed'
