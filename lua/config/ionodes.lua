local M = {}
local running = {}
local completion_choices

function M.complete(lead)
  local matches = {}
  for _, choice in ipairs(completion_choices and completion_choices() or {}) do
    if vim.startswith(choice, lead) then
      matches[#matches + 1] = choice
    end
  end
  return matches
end

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = 'Ionodes' })
end

local function repository_root()
  local start = vim.api.nvim_buf_get_name(0)
  start = start ~= '' and vim.bo.buftype == '' and start or vim.fn.getcwd()
  return vim.fs.root(start, '.git')
end

local function quote_args(args)
  return table.concat(vim.tbl_map(vim.fn.shellescape, args), ' ')
end

local function build(root, options, sdk)
  local args = { 'bash', './build.sh', '-m', options.module, '-b', options.family }
  if options.target ~= 'Board default' then
    vim.list_extend(args, { '-t', options.target })
  end
  if options.mode == 'Debug' then
    args[#args + 1] = '-d'
  end

  local output = root .. '/.ionodes-compile-' .. vim.uv.hrtime() .. '.json'
  local commands = {}
  if sdk ~= '' then
    commands[#commands + 1] = 'source ' .. vim.fn.shellescape(sdk)
  end
  if options.clean == 'Clean selected module first' then
    commands[#commands + 1] = quote_args(vim.list_extend(vim.deepcopy(args), { '-c' }))
  end
  commands[#commands + 1] = quote_args(vim.list_extend({ 'bear', '--output', output, '--' }, args))
  local command = table.concat(commands, ' && ')

  vim.ui.select({ 'Run', 'Cancel' }, {
    prompt = ('Bear: %s / %s / %s / %s / %s'):format(options.module, options.family, options.target, options.mode, options.clean),
  }, function(choice)
    if choice ~= 'Run' then
      return
    end
    if running[root] then
      notify('A capture is already running for ' .. root, vim.log.levels.WARN)
      return
    end
    running[root] = true
    vim.cmd 'botright new'
    local job = vim.fn.jobstart({ 'bash', '-c', command }, {
      cwd = root,
      term = true,
      on_exit = function(_, code)
        vim.schedule(function()
          running[root] = nil
          if code ~= 0 then
            vim.fn.delete(output)
            notify('Build/capture failed (exit ' .. code .. '). See the terminal; the previous database is unchanged.', vim.log.levels.ERROR)
            return
          end
          local file, open_error = io.open(output, 'r')
          if not file then
            notify('Cannot read Bear output: ' .. tostring(open_error), vim.log.levels.ERROR)
            return
          end
          local content = file:read '*a'
          file:close()
          local ok, entries = pcall(vim.json.decode, content)
          if not ok or type(entries) ~= 'table' or not vim.islist(entries) or #entries == 0 then
            vim.fn.delete(output)
            notify(
              'Bear produced no valid compilation entries. Recompile sources (choose clean first); the previous database is unchanged.',
              vim.log.levels.ERROR
            )
            return
          end
          local renamed, err = vim.uv.fs_rename(output, root .. '/compile_commands.json')
          if not renamed then
            notify('Cannot publish compilation database: ' .. tostring(err) .. '. Capture saved at ' .. output, vim.log.levels.ERROR)
            return
          end
          notify(('Captured %d commands in %s/compile_commands.json. Restart clangd if needed.'):format(#entries, root))
        end)
      end,
    })
    if job <= 0 then
      running[root] = nil
      vim.fn.delete(output)
      notify('Could not start the Bear terminal.', vim.log.levels.ERROR)
      return
    end
    vim.cmd 'startinsert'
  end)
end

local function configure(root)
  root = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(root), ':p')):gsub('/$', '')
  if vim.fn.filereadable(root .. '/build.sh') ~= 1 or vim.fn.isdirectory(root .. '/Build/linux/target') ~= 1 then
    notify('Not an Ionodes build root: ' .. root, vim.log.levels.ERROR)
    return
  end
  local function modules()
    local names = {}
    for path, kind in
      vim.fs.dir(root, {
        depth = math.huge,
        skip = function(path)
          local name = vim.fs.basename(path)
          return name:sub(1, 1) ~= '.' and not name:match '%.build$' and name ~= 'node_modules'
        end,
      })
    do
      if kind == 'file' and vim.fs.basename(path) == 'Makefile' and path ~= 'Makefile' then
        names[#names + 1] = vim.fs.dirname(path)
      end
    end
    table.sort(names)
    return names
  end
  local function makefiles(directory, excluded)
    local names = {}
    for name, kind in vim.fs.dir(root .. '/Build/linux/' .. directory) do
      if kind == 'file' and name:match '%.mk$' and name ~= excluded then
        names[#names + 1] = name:gsub('%.mk$', '')
      end
    end
    table.sort(names)
    return names
  end
  local fields = {
    { key = 'module', prompt = 'Module to compile', choices = modules },
    {
      key = 'family',
      prompt = 'Board family',
      choices = function()
        return makefiles('family', 'board_families.mk')
      end,
    },
    {
      key = 'target',
      prompt = 'Target toolchain',
      default = 'Board default',
      choices = function()
        local targets = makefiles 'target'
        table.insert(targets, 1, 'Board default')
        return targets
      end,
    },
    { key = 'mode', prompt = 'Build configuration', choices = { 'Debug', 'Release' } },
    { key = 'clean', prompt = 'Capture mode (incremental captures only recompiled files)', choices = { 'Clean selected module first', 'Incremental' } },
  }
  local options = {}
  local function select(index)
    local field = fields[index]
    if not field then
      vim.ui.input({ prompt = 'SDK environment script (blank = inherited environment): ', completion = 'file' }, function(sdk)
        if sdk == nil then
          return
        end
        sdk = sdk ~= '' and vim.fn.fnamemodify(vim.fn.expand(sdk), ':p') or ''
        if sdk ~= '' and vim.fn.filereadable(sdk) ~= 1 then
          notify('SDK environment script is not readable: ' .. sdk, vim.log.levels.ERROR)
          return
        end
        build(root, options, sdk)
      end)
      return
    end
    local dynamic = type(field.choices) == 'function'
    local choices = dynamic and field.choices() or field.choices
    if #choices == 0 then
      notify('No choices found for ' .. field.prompt, vim.log.levels.ERROR)
      return
    end
    local function accept(choice)
      completion_choices = nil
      if choice == nil then
        return
      end
      local current = dynamic and field.choices() or choices
      if not vim.list_contains(current, choice) then
        notify('Invalid ' .. field.prompt .. ': ' .. choice, vim.log.levels.ERROR)
        select(index)
        return
      end
      options[field.key] = choice
      select(index + 1)
    end
    if dynamic then
      completion_choices = field.choices
      vim.ui.input({
        prompt = field.prompt .. ': ',
        default = field.default,
        completion = "customlist,v:lua.require'config.ionodes'.complete",
      }, accept)
    else
      vim.ui.select(choices, { prompt = field.prompt }, accept)
    end
  end
  select(1)
end

function M.cpp()
  local root = repository_root()
  if not root or vim.fn.filereadable(root .. '/build.sh') ~= 1 or vim.fn.isdirectory(root .. '/Build/linux/target') ~= 1 then
    notify('Not in an Ionodes repository.', vim.log.levels.WARN)
    return
  end
  if vim.fn.has 'win32' == 1 then
    notify('Bear capture requires Linux/WSL Neovim and the Linux SDK. Native Windows MSBuild capture is not supported.', vim.log.levels.ERROR)
    return
  end
  for _, executable in ipairs { 'bear', 'bash', 'make' } do
    if vim.fn.executable(executable) ~= 1 then
      notify(executable .. ' is missing from Neovim PATH.', vim.log.levels.ERROR)
      return
    end
  end
  configure(root)
end

function M.import()
  local root = repository_root()
  if not root or vim.fn.isdirectory(root .. '/Import') ~= 1 then
    notify('Not in a repository with an Import directory.', vim.log.levels.WARN)
    return
  end
  if vim.fn.executable 'launchpad' ~= 1 then
    notify('launchpad is missing from Neovim PATH.', vim.log.levels.ERROR)
    return
  end
  local function files()
    local names = {}
    for name, kind in vim.fs.dir(root .. '/Import') do
      if kind == 'file' and name:match '%.txt$' then
        names[#names + 1] = name
      end
    end
    table.sort(names)
    return names
  end
  if #files() == 0 then
    notify('No Import/*.txt files found.', vim.log.levels.WARN)
    return
  end
  completion_choices = files
  vim.ui.input({
    prompt = 'Import file: ',
    completion = "customlist,v:lua.require'config.ionodes'.complete",
  }, function(file)
    completion_choices = nil
    if file == nil then
      return
    end
    if not vim.list_contains(files(), file) then
      notify('Invalid import file: ' .. file, vim.log.levels.ERROR)
      return
    end
    vim.cmd 'botright new'
    local job = vim.fn.jobstart({ 'launchpad', 'import', root .. '/Import/' .. file }, {
      cwd = root,
      term = true,
      on_exit = function(_, code)
        vim.schedule(function()
          if code ~= 0 then
            notify('Launchpad import failed (exit ' .. code .. '). See the terminal.', vim.log.levels.ERROR)
          else
            notify('Launchpad import completed: ' .. file)
          end
        end)
      end,
    })
    if job <= 0 then
      notify('Could not start the Launchpad terminal.', vim.log.levels.ERROR)
      return
    end
    vim.cmd 'startinsert'
  end)
end

return M
