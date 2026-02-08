-- send OSC 7 for wezterm repaint
-- NOTE: without this, wezterm tab title will show C:\WINDOWS\ when directory changed
----------------------------------------

function set_user_vars(prompt_begin, prompt_end)
  -- OSC 7 for CWD
  clink.prompt.value = clink.prompt.value
  .. "\x1b]7;file://"
  .. clink.get_cwd()
  .. "\x1b\\"
end

clink.prompt.register_filter(set_user_vars, 50)

-- update console title
----------------------------------------

function starship_preprompt_user_func(prompt)
  local cwd = os.getcwd()
  local prj = path.getname(cwd)
  if prj == '' then
    prj = ''
  else
    prj = '['..prj..'] '
  end

  console.settitle(prj..cwd)
end

-- use starship for prompt
----------------------------------------

load(io.popen('starship init cmd'):read("*a"))()

-- use clink-completions for completions
----------------------------------------

local completions_dir = clink.get_env('USERPROFILE')..'/bin/clink-completions/'

-- Execute '.init.lua' first to ensure package.path is set properly
dofile(completions_dir..'!init.lua')

for _,lua_module in ipairs(clink.find_files(completions_dir..'*.lua')) do
  -- Skip files that starts with _. This could be useful if some files should be ignored
  if not string.match(lua_module, '^_.*') then
    local filename = completions_dir..lua_module
    -- use dofile instead of require because require caches loaded modules
    -- so config reloading using Alt-Q won't reload updated modules.
    dofile(filename)
  end
end
