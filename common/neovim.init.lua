-- /////////////////////////////////////////////////////////////////////////////
-- basic
-- /////////////////////////////////////////////////////////////////////////////

local is_win = jit.os == 'Windows'
local is_mac = jit.os == 'OSX'
local is_linux = jit.os == 'Linux'

-- color16 settings
local is_color16 = false
local indent_char = '▏'

if is_linux then
  is_color16 = vim.env.TERM == 'linux'
  indent_char = '|'
end

-- neovide settings
if vim.g.neovide then
  -- rendering
  vim.g.neovide_no_idle = true
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 60

  -- text rendering
  vim.g.neovide_scale_factor = 1.0 -- NOTE: adjust by your system font scale factor
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.5
  vim.g.neovide_underline_stroke_scale = 1.0

  -- animation
  vim.g.neovide_position_animation_length = 0.3
  vim.g.neovide_scroll_animation_length = 0.0
  vim.g.neovide_scroll_animation_far_lines = 0.0
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_short_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_smooth_blink = false

  -- others
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_input_ime = false
  vim.g.neovide_input_macos_option_key_is_meta = 'only_left' -- set to true to make sure M-1 works

  -- IME only work in Insert Mode
  local function set_ime(args)
    if args.event:match('Enter$') then
      vim.g.neovide_input_ime = true
    else
      vim.g.neovide_input_ime = false
    end
  end
  local ime_input = vim.api.nvim_create_augroup('ime_input', { clear = true })

  vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
    group = ime_input,
    pattern = '*',
    callback = set_ime
  })

  -- NOTE: Disabled
  -- vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'CmdlineLeave' }, {
  --   group = ime_input,
  --   pattern = '[/\\?]',
  --   callback = set_ime
  -- })
end

-- DELME: {
local function OSX()
  return vim.uv.os_uname().sysname == 'Darwin'
end

local function LINUX()
  return vim.uv.os_uname().sysname == 'Linux'
end

local function WINDOWS()
  return vim.uv.os_uname().sysname == 'Windows_NT'
end

_G.OSX = OSX
_G.LINUX = LINUX
_G.WINDOWS = WINDOWS
-- } DELME:

-- /////////////////////////////////////////////////////////////////////////////
-- language and encoding setup
-- /////////////////////////////////////////////////////////////////////////////

-- always use English menu
-- NOTE: this must before filetype off, otherwise it won't work
vim.opt.langmenu = 'none'

-- use English for anaything in vim-editor.
if is_win then
  vim.cmd('language english')
elseif is_mac then
  vim.cmd('language en_US.UTF-8')
else
  vim.cmd('language en_US.utf8')
end

-- try to set encoding to utf-8
if is_win then
  -- Let Vim use utf-8 internally, because many scripts require this
  vim.opt.encoding = 'utf-8'
  vim.bo.fileencoding = 'utf-8'

  -- Windows has traditionally used cp1252, so it's probably wise to
  -- fallback into cp1252 instead of eg. iso-8859-15.
  -- Newer Windows files might contain utf-8 or utf-16 LE so we might
  -- want to try them first.
  vim.opt.fileencodings = 'ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15'
else
  -- set default encoding to utf-8
  vim.opt.encoding = 'utf-8'
  vim.opt.fileencoding = 'utf-8'
end

vim.scriptencoding = 'utf-8'

-- /////////////////////////////////////////////////////////////////////////////
-- General
-- /////////////////////////////////////////////////////////////////////////////

vim.opt.backup = true -- make backup file and leave it around

-- setup back and swap directory
local data_dir = vim.env.HOME .. '/.data/'
local backup_dir = data_dir .. 'backup'
local swap_dir = data_dir .. 'swap'

if vim.fn.finddir(data_dir) == '' then
  vim.fn.mkdir(data_dir, 'p', '0700')
end

if vim.fn.finddir(backup_dir) == '' then
  vim.fn.mkdir(backup_dir, 'p', '0700')
end

if vim.fn.finddir(swap_dir) == '' then
  vim.fn.mkdir(swap_dir, 'p', '0700')
end

vim.opt.backupdir = vim.env.HOME .. '/.data/backup' -- where to put backup file
vim.opt.directory = vim.env.HOME .. '/.data/swap' -- where to put swap file

-- Redefine the shell redirection operator to receive both the stderr messages and stdout messages
vim.opt.shellredir = '>%s 2>&1'
vim.opt.history = 50 -- keep 50 lines of command line history
vim.opt.updatetime = 1000 -- default = 4000
vim.opt.autoread = true -- auto read same-file change (better for vc/vim change)
vim.opt.maxmempattern = 1000 -- enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)


-- /////////////////////////////////////////////////////////////////////////////
-- Variable settings (set all)
-- /////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------
-- Desc: Appearance
--------------------------------------------------------------------

vim.opt.matchtime = 0 -- 0 second to show the matching paren (much faster)
vim.opt.number = true -- show line number
vim.opt.scrolloff = 0 -- minimal number of screen lines to keep above and below the cursor
vim.opt.wrap = false -- do not wrap text
vim.opt.autochdir = false -- no autochchdir

if is_win then
  if vim.g.neovide then
    vim.g.neovide_scroll_animation_length = 0.3
    vim.g.neovide_scroll_animation_far_lines = 0.3
  end

  vim.opt.guifont = 'FiraMono Nerd Font,Microsoft YaHei Mono:h12'
elseif is_mac then
  vim.opt.guifont = 'FiraMono Nerd Font,PingFang SC:h16'
else
  vim.opt.guifont = 'FiraMono Nerd Font:h12'
end

--------------------------------------------------------------------
-- Desc: Vim UI
--------------------------------------------------------------------

vim.opt.wildmenu = true -- turn on wild menu, try typing :h and press <Tab>
vim.opt.showcmd = true -- display incomplete commands
vim.opt.cmdheight = 1 -- 1 screen lines to use for the command-line
vim.opt.ruler = true -- show the cursor position all the time
vim.opt.hidden = true -- allow to change buffer without saving
vim.opt.shortmess = 'aoOtTI' -- shortens messages to avoid 'press a key' prompt
vim.opt.lazyredraw = true -- do not redraw while executing macros (much faster)
vim.opt.display = 'lastline' -- for easy browse last line with wrap text
vim.opt.laststatus = 2 -- always have status-line
vim.opt.title = true
vim.opt.titlestring = '%t (%{expand("%:p:h")})'

-- set window size (if it's GUI)
-- set window's width to 130 columns and height to 40 rows
-- vim.opt.lines = 40
-- vim.opt.columns = 130
vim.opt.showfulltag = true -- show tag with function protype.
vim.opt.signcolumn = 'auto'

vim.opt.mousemoveevent = true

-- disable menu, toolbar and scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'm' -- disable Menu
-- vim.opt.guioptions = vim.opt.guioptions - 'T' -- disalbe Toolbar
-- vim.opt.guioptions = vim.opt.guioptions - 'b' -- disalbe the bottom scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'l' -- disalbe the left scrollbar
-- vim.opt.guioptions = vim.opt.guioptions - 'L' -- disalbe the left scrollbar when the longest visible line exceed the window

-- diagnostic
vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  virtual_lines = false,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
    }
  }
})

--------------------------------------------------------------------
-- Desc: Text edit
--------------------------------------------------------------------

vim.opt.ai = true -- autoindent
vim.opt.si = true -- smartindent
vim.opt.backspace = 'indent,eol,start' -- allow backspacing over everything in insert mode
-- indent options
-- see help cinoptions-values for more details
-- set cinoptions=>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,k0,m0,j0,J0,)20,*70,#0
vim.opt.cinoptions = '>s,e0,n0,f0,{0,}0,^0,L0:0,=s,l0,b0,g0,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(0,us,U0,w0,Ws,m1,M0,j1,J1,)20,*70,#0'
-- default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
-- set cinkeys=0{,0},0),:,!^F,o,O,e

vim.opt.smartindent = true
vim.opt.cindent = true -- set cindent on to autoinent when editing c/c++ file
vim.opt.shiftwidth = 2 -- 2 shift width
vim.opt.tabstop = 2 -- set tabstop to 4 characters
vim.opt.expandtab = true -- set expandtab on, the tab will be change to space automaticaly
vim.opt.ve = 'block' -- in visual block mode, cursor can be positioned where there is no actual character

-- set Number format to null(default is octal), when press CTRL-A on number
-- like 007, it would not become 010
vim.opt.nf = ''
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'

--------------------------------------------------------------------
-- Desc: Fold text
--------------------------------------------------------------------

vim.opt.foldmethod = 'marker'
vim.opt.foldmarker = '{,}'
vim.opt.foldlevel = 9999
vim.opt.diffopt = { 'internal', 'filler', 'closeoff', 'algorithm:histogram', 'indent-heuristic', 'linematch:60', 'context:9999' }

--------------------------------------------------------------------
-- Desc: Search
--------------------------------------------------------------------

vim.opt.showmatch = true -- show matching paren
vim.opt.incsearch = true -- do incremental searching
vim.opt.hlsearch = true -- highlight search terms
vim.opt.ignorecase = true -- set search/replace pattern to ignore case
vim.opt.smartcase = true -- set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

-- /////////////////////////////////////////////////////////////////////////////
--  Key Mappings
-- /////////////////////////////////////////////////////////////////////////////

-- NOTE: F10 looks like have some feature, when map with F10, the map will take no effects

-- Don't use Ex mode, use Q for formatting
vim.keymap.set('', 'Q', 'gq')

-- define the copy/paste judged by clipboard
-- general copy/paste.
-- NOTE: y,p,P could be mapped by other key-mapping
vim.keymap.set('', '<leader>y', '"*y')
vim.keymap.set('', '<leader>p', '"*p')
vim.keymap.set('', '<leader>P', '"*P')

-- copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
vim.keymap.set('n', '<leader>y1', ':let @*=fnamemodify(bufname("%"),":p:h")<CR>', { noremap = true, silent = true })

-- copy file name to clipboard, foo/bar/foobar.c => foobar.c
vim.keymap.set('n', '<leader>y2', ':let @*=fnamemodify(bufname("%"),":p:t")<CR>', { noremap = true, silent = true })

-- copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c
vim.keymap.set('n', '<leader>y3', ':let @*=fnamemodify(bufname("%"),":p")<CR>', { noremap = true, silent = true })

-- F8 or <leader>/:  Set Search pattern highlight on/off
vim.keymap.set('n', '<leader>\\', ':let @/=""<CR>', { noremap = true, silent = true })
-- DISABLE: though nohlsearch is standard way in Vim, but it will not erase the
--          search pattern, which is not so good when use it with exVim's <leader>r
--          filter method
-- nnoremap <leader>\ :nohlsearch<CR>

-- map Ctrl-Tab to switch window
vim.keymap.set('n', '<S-Up>', '<C-W><Up>', { noremap = true })
vim.keymap.set('n', '<S-Down>', '<C-W><Down>', { noremap = true })
vim.keymap.set('n', '<S-Left>', '<C-W><Left>', { noremap = true })
vim.keymap.set('n', '<S-Right>', '<C-W><Right>', { noremap = true })

-- DISABLE
-- map Ctrl-Space to Omni Complete
-- vim.keymap.set('i', '<C-Space>', '<C-X><C-O>', { noremap = true })

-- -- NOTE: if we already map to EXbn,EXbp. skip setting this
-- -- easy buffer navigation
-- if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
--   nnoremap <C-l> :bn<CR>
-- endif
-- if !hasmapto(':EXbp<CR>') && mapcheck('<C-h>','n') == ''
--   noremap <C-h> :bp<CR>
-- endif

-- easy diff goto
vim.keymap.set('', '<C-k>', '[c', { noremap = true })
vim.keymap.set('', '<C-j>', ']c', { noremap = true })

-- enhance '<' '>' , do not need to reselect the block after shift it.
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

-- map Up & Down to gj & gk, helpful for wrap text edit
vim.keymap.set('', '<Up>', 'gk', { noremap = true })
vim.keymap.set('', '<Down>', 'gj', { noremap = true })

-- VimTip 329: A map for swapping words
-- http://vim.sourceforge.net/tip_view.php?tip_id=
-- Then when you put the cursor on or in a word, press "\sw", and
-- the word will be swapped with the next word.  The words may
-- even be separated by punctuation (such as "abc = def").
vim.keymap.set('n', '<leader>sw', '"_yiw:s/(%#w+)(W+)(w+)/321/<cr><c-o>', { noremap = true, silent = true })

-- NOTE: au must after filetype plug, otherwise they won't work
-- /////////////////////////////////////////////////////////////////////////////
-- Auto Command
-- /////////////////////////////////////////////////////////////////////////////

--------------------------------------------------------------------
-- Desc: Only do this part when compiled with support for autocommands.
--------------------------------------------------------------------

local ex_group = vim.api.nvim_create_augroup('ex', { clear = true })

-- when editing a file, always jump to the last known cursor position.
-- don't do it when the position is invalid or when inside an event handler
-- (happens when dropping a file on gvim).
vim.api.nvim_create_autocmd('BufReadPost', {
  group = ex_group,
  pattern = {'*'},
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- NOTE: ctags find the tags file from the current path instead of the path of currect file
vim.api.nvim_create_autocmd({'BufNewFile', 'BufEnter'}, {
  group = ex_group,
  pattern = {'*'},
  command = 'set cpoptions+=d',
})

-- ensure every file does syntax highlighting (full)
vim.api.nvim_create_autocmd({'BufEnter'}, {
  group = ex_group,
  pattern = {'*'},
  command = 'syntax sync fromstart',
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = ex_group,
  pattern = {'*.hlsl', '*.shader', '*.cg', '*.cginc', '*.vs', '*.fs', '*.fx', '*.fxh', '*.vsh', '*.psh', '*.shd'},
  command = 'set ft=hlsl',
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = ex_group,
  pattern = {'*.glsl'},
  command = 'set ft=glsl',
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = ex_group,
  pattern = {'*.avs'},
  command = 'set syntax=avs',
})

--------------------------------------------------------------------
-- Desc: file types
--------------------------------------------------------------------

-- for all text files set 'textwidth' to 78 characters.
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'text'},
  command = 'setlocal textwidth=78',
})

-- this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.
-- au FileType c,cpp,cs,swig set nomodeline
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'c', 'cpp', 'cs', 'swig'},
  command = 'set nomodeline',
})

-- disable auto-comment for c/cpp, lua, javascript, c# and vim-script
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'c', 'cpp', 'java', 'javascript'},
  command = [[set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://]],
})
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'cs'},
  command = [[set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://]],
})
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'vim'},
  command = [[set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"]],
})
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'lua'},
  command = [[set comments=f:--]],
})

-- disable automaticaly insert current comment leader after hitting <Enter>, 'o' or 'O'
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'c', 'cpp', 'cs', 'rust', 'vim'},
  command = 'set formatoptions-=ro',
})

-- if edit python scripts, check if have \t. (python said: the programme can only use \t or not, but can't use them together)
vim.api.nvim_create_autocmd({'FileType'}, {
  group = ex_group,
  pattern = {'python', 'coffee'},
  callback = function()
    local has_noexpandtab = vim.fn.search('^\t','wn')
    local has_expandtab = vim.fn.search('^    ','wn')

    if has_noexpandtab and has_expandtab then
      local idx = vim.fn.inputlist({
        'ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
        '1. expand (tab=space, recommended)',
        '2. noexpand (tab=\t, currently have risk)',
        '3. do nothing (I will handle it by myself)'
      })
      local tab_space = vim.fn.printf('%*s',vim.o.tabstop)
      if idx == 1 then
        has_noexpandtab = 0
        has_expandtab = 1
        vim.cmd('%s/\t/' .. tab_space .. '/g')
      elseif idx == 2 then
        has_noexpandtab = 1
        has_expandtab = 0
        vim.cmd('%s/' .. tab_space .. '/\t/g')
      else
        return
      end
    end

    if has_noexpandtab == 1 and has_expandtab == 0 then
      print('substitute space to TAB...')
      vim.opt.expandtab = false
      print('done!')
    elseif has_noexpandtab == 0 and has_expandtab == 1 then
      print('substitute space to space...')
      vim.opt.expandtab = true
      print('done!')
    else
      -- it may be a new file
      -- we use original vim setting
    end
  end,
})

-- /////////////////////////////////////////////////////////////////////////////
-- User Commands
-- /////////////////////////////////////////////////////////////////////////////

-- FIXME:
vim.api.nvim_create_user_command('SH', function()
  vim.fn.jobstart(
    { 'd:\\alacritty\\alacritty', '--working-directory', vim.fn.expand('%:p:h') },
    { detach = true }
  )
end, {})

-- /////////////////////////////////////////////////////////////////////////////
-- Plugs
-- /////////////////////////////////////////////////////////////////////////////

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  ------------------------------
  -- color theme
  ------------------------------

  {
    'navarasu/onedark.nvim',
    priority = 100,
    dependencies = { 'RRethy/base16-nvim' },
    config = function()
      require('onedark').setup {
        style = 'dark',
        transparent = false,
        term_colors = true,
        ending_tildes = false,
        cmp_itemkind_reverse = false,

        -- Options are italic, bold, underline, none
        code_style = {
          comments = 'none',
          keywords = 'none',
          functions = 'none',
          strings = 'none',
          variables = 'none'
        },

        lualine = {
          transparent = false,
        },

        -- Custom Highlights --
        colors = {},
        highlights = {
          -- exvim/ex-easyhl
          ['EX_HL_label1'] = { bg = 'darkred'},
          ['EX_HL_label2'] = { bg = 'darkmagenta'},
          ['EX_HL_label3'] = { bg = 'darkblue'},
          ['EX_HL_label4'] = { bg = 'darkgreen'},

          -- 'exvim/ex-showmarks'
          ['ShowMarksHLl'] = { bg = 'slateblue', fmt = 'none' },
          ['ShowMarksHLu'] = { fg = 'darkred', bg = 'lightred', fmt = 'bold' },
        },

        -- Plugins Config --
        diagnostics = {
          darker = true,
          undercurl = true,
          background = true,
        },
      }
      require('onedark').load()

      -- setup neovide window-title color after onedark loaded
      if vim.g.neovide then
        vim.g.neovide_title_background_color = string.format(
          '%x',
          vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name('Normal')}).bg
        )
        vim.g.neovide_title_text_color = string.format(
          '%x',
          vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name('Normal')}).fg
        )
      end

      -- color16 setup
      if is_color16 then
        vim.cmd.colorscheme('base16-onedark')
      end
    end
  },

  ------------------------------
  -- snacks.nvim
  ------------------------------

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = {
        enabled = true,
        notify = true,
        size = 1.5 * 1024 * 1024, -- 1.5MB
        line_length = 1000, -- average line length (useful for minified files)
      },
      dashboard = { enabled = true },
      explorer = {
        enabled = true,
      },
      indent = {
        indent = {
          enabled = true,
          char = indent_char
        },
        scope = {
          enabled = true, -- enable highlighting the current scope
          char = indent_char
        },
        animate= {
          enabled = false
        },
      },
      input = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            jump = { close = true }
          }
        }
      },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 5, total = 50 },
          easing = 'linear',
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = 'linear',
        },
      },
      statuscolumn = {
        enabled = false,
        left = { 'mark', 'sign', 'git', 'fold' }, -- priority of signs on the left (high to low)
        right = {}, -- priority of signs on the right (high to low)
        folds = {
          open = false, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          patterns = { 'GitSign', 'MiniDiffSign' },
        },
        refresh = 50, -- refresh at most every 50ms,
      },
      words = { enabled = false },
    },
    keys = {
      -- finder
      { '<c-p>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
      { 'f/', function() Snacks.picker.files() end, desc = 'Find Files' },
      { 'g/', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
      { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
      { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },

      -- git
      { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
      { '<leader>df', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
      { '<leader>gb', function() Snacks.gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' } },

      -- Buffer
      { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
      { '<leader>t', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
    },
  },

  ------------------------------
  -- exvim-lite
  ------------------------------

  -- DELME:
  {
    'jwu/exvim-lite',
    config = function()
      local function strip_ws()
        vim.cmd('StripWhitespace')
        print('whitespace striped!')
      end

      -- buffer operation
      -- vim.keymap.set('n', '<leader>bd', ':EXbd<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.del('n', '<C-l>')
      vim.keymap.set('n', '<C-l>', ':EXbn<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<C-h>', ':EXbp<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<C-Tab>', ':EXbalt<CR>', { noremap = true, silent = true, unique = true })

      -- plugin<->edit window switch
      vim.keymap.set('n', '<leader><Tab>', ':EXsw<CR>', { noremap = true, silent = true, unique = true })
      vim.keymap.set('n', '<leader><Esc>', ':EXgc<CR>', { noremap = true, silent = true, unique = true })

      -- search
      vim.keymap.set('n', '<leader>F', ':GS<space>', { noremap = true, unique = true })
      vim.keymap.set('n', '<leader>gg', ':EXSearchCWord<CR>', { noremap = true, unique = true })
      vim.keymap.set('n', '<leader>gs', ':call ex#search#toggle_window()<CR>', { noremap = true, unique = true })

      -- plugin hotkey
      vim.keymap.set('n', '<leader>w', strip_ws, { noremap = true, unique = true })
    end,
  },

  ------------------------------
  -- visual enhancement
  ------------------------------

  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local bufferline = require('bufferline')

      _G.show_bufferline = function()
        local config = require('bufferline.config')
        config.options.always_show_bufferline = true
      end

      bufferline.setup {
        highlights = {
          buffer_selected = {
            bold = true,
            italic = false,
          },
        },
        options = {
          mode = 'buffers',
          style_preset = bufferline.style_preset.default,
          themable = true,
          separator_style = 'thick',
          always_show_bufferline = false,
          hover = {
            enabled = true,
            delay = 100,
            reveal = {'close'}
          },
          offsets = {
            {
              filetype = 'NvimTree',
              text = function()
                return vim.fn.getcwd()
              end,
              highlight = 'Directory',
              separator = true,
              text_align = 'left',
            },
            {
              filetype = 'exproject',
              text = function()
                return vim.fn.getcwd()
              end,
              highlight = 'Directory',
              separator = true,
              text_align = 'left',
            }
          }
        },
      }
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- local function lineinfo()
      --   return "%p%% %l:%v %{line('$')}"
      -- end
      local function projectinfo()
        return 'Project'
      end
      local function searchinfo()
        return 'Search Results'
      end

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'onedark',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {'filename'},
          lualine_x = {'filetype'},
          lualine_y = {'encoding', 'fileformat'},
          lualine_z = {'progress', 'location'}
          -- lualine_z = {lineinfo}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'filetype'},
          lualine_y = {'encoding', 'fileformat'},
          lualine_z = {'progress', 'location'}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          {
            filetypes = {'exproject', 'NvimTree'},
            sections = {
              lualine_a = {projectinfo},
              lualine_b = {'progress'},
              lualine_c = {'location'},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {}
            }
          },
          {
            filetypes = {'exsearch'},
            sections = {
              lualine_a = {searchinfo},
              lualine_b = {'progress'},
              lualine_c = {'location'},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {}
            }
          },
        }
      }

      -- color16 setup
      if is_color16 then
        require('lualine').setup{
          options = {
            icons_enabled = false,
            theme = '16color',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
          }
        }
      end
    end,
  },

  {
    'petertriho/nvim-scrollbar',
    dependencies = {
      'kevinhwang91/nvim-hlslens',
      'lewis6991/gitsigns.nvim',
    },
    config = function()
      require('gitsigns').setup {
        update_debounce = 50,
      }
      require('scrollbar.handlers.gitsigns').setup()

      require('scrollbar.handlers.search').setup {
        override_lens = function() end, -- leave only search marks and disable virtual text
      }

      require('scrollbar').setup {
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
        max_lines = false, -- disables if no. of lines in buffer exceeds this
        hide_if_all_visible = false, -- Hides everything if all lines are visible
        throttle_ms = 100,
        handle = {
          text = ' ',
          blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
          color = nil,
          color_nr = nil, -- cterm
          highlight = 'Tabline',
          hide_if_all_visible = true, -- Hides handle if all lines are visible
        },
        marks = {
          Cursor = {
            text = '•',
            priority = 0,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'Normal',
          },
          Search = {
            text = { '-', '=' },
            priority = 1,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'Type',
          },
          GitAdd = {
            text = '┆',
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'GitSignsAdd',
          },
          GitChange = {
            text = '┆',
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'GitSignsChange',
          },
          GitDelete = {
            text = '▁',
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = 'GitSignsDelete',
          },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          handle = true,
          search = true, -- Requires hlslens
          ale = false, -- Requires ALE
          gitsigns = false, -- Requires gitsigns
        },
      }
    end,
  },

  ------------------------------
  -- text highlight
  ------------------------------

  {
    'exvim/ex-easyhl',
  },

  {
    'exvim/ex-showmarks',
    init = function()
      vim.g.showmarks_enable = 1
      vim.g.showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

      -- Ignore help, quickfix, non-modifiable buffers
      vim.g.showmarks_ignore_type = 'hqm'

      -- Hilight lower & upper marks
      vim.g.showmarks_hlline_lower = 1
      vim.g.showmarks_hlline_upper = 0
    end,
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      sign_priority = 8,
      keywords = {
        FIX  = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, },
        DEL  = { icon = ' ', color = 'error', alt = { 'DELME' }, },
        TODO = { icon = ' ', color = 'info' },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTME', 'TESTING', 'PASSED', 'FAILED' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      },
      gui_style = {
        fg = 'NONE',
        bg = 'BOLD',
      },
      merge_keywords = true,
      highlight = {
        multiline = false,
        multiline_pattern = '^.',
        multiline_context = 10,
        before = '',
        keyword = 'bg',
        after = '',
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
    }
  },

  -- TODO: some usefule plugin
  -- {
  --   'RRethy/vim-illuminate',
  --   config = function()
  --     require('illuminate').configure{
  --       delay = 100,
  --     }
  --   end,
  -- },
  -- {
  --   'kevinhwang91/nvim-ufo',
  -- },

  ------------------------------
  -- syntax highlight/check
  ------------------------------

  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        compilers = { 'zig', 'clang', 'gcc', 'cl' },
        install_dir = vim.fn.stdpath('data') .. '/site'
      }

      require('nvim-treesitter').install {
        'c', 'cpp', 'c_sharp', 'rust', 'go',
        'python', 'lua', 'javascript', 'typescript', 'vim',
        'css', 'hlsl', 'glsl', 'wgsl',
        'json', 'toml', 'yaml', 'xml', 'html',
        'luadoc', 'vimdoc', 'markdown', 'markdown_inline',
        'diff', 'query',
      }

      local indent_blacklist = {
        c = true,
        cpp = true,
        python = true,
        ruby = true,
        lua = true,
        yaml = true,
      }

      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local ok, _ = pcall(vim.treesitter.start)

          -- if we have the parser for the target language
          if ok then
            vim.opt_local.foldmethod = 'expr'
            vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.opt_local.foldenable = false
            vim.opt_local.foldtext = ''
            vim.opt_local.foldlevel = 9999

            local ft = vim.bo.filetype
            if not indent_blacklist[ft] then
              vim.bo.indentexpr = 'v:lua.vim.treesitter.indent.get()'
            end
          end
        end,
      })
    end,
  },


  'tikhomirov/vim-glsl',
  'drichardson/vex.vim',
  'cespare/vim-toml',

  ------------------------------
  -- complete
  ------------------------------

  {
    'saghen/blink.cmp',
    -- DELME:
    -- dependencies = {
    --   'L3MON4D3/LuaSnip',
    -- },

    version = '1.*',

    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'super-tab',
        ['<Enter>'] = { 'select_and_accept', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      completion = {
        -- only show menu on manual <C-space>
        menu = { auto_show = false },
        documentation = { auto_show = false },
        ghost_text = { enabled = true, show_with_menu = true },
        list = {
          selection = { preselect = true, auto_insert = false },
        }
      },

      -- DELME:
      -- snippets = {
      --   expand = function(snippet)
      --     require('luasnip').lsp_expand(snippet)
      --   end,
      -- },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = 'cmdline',
          ['<Enter>'] = { 'select_and_accept', 'fallback' },
          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
        },
        sources = { 'buffer', 'cmdline' },
        completion = {
          menu = { auto_show = false },
          ghost_text = { enabled = true },
          list = {
            selection = { preselect = true, auto_insert = false },
          }
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' }
    },
  },

  -- NOTE: Use this instead of  nvim-cmp cmdline({ '/', '?' }, ...)
  -- NOTE: nvim-cmp will random jump cursor when working with ex-gsearch window
  'exvim/ex-searchcompl',

  ------------------------------
  -- lsp
  ------------------------------

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp'
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      vim.lsp.config('clangd', {
        capabilities = capabilities,
      })
      vim.lsp.config('omnisharp', {
        capabilities = capabilities,
      })
      vim.lsp.config('rust_analyzer', {
        capabilities = capabilities,
      })
      vim.lsp.config('pyright', {
        capabilities = capabilities,
      })
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                'vim'
              },
              disable = {
                'missing-fields'
              }
            },
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths here.
                -- '${3rd}/luv/library'
                -- '${3rd}/busted/library'
              }
            }
          }
        }
      })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          local opts = { noremap = true, silent = true, buffer = ev.buf }
          vim.keymap.set('n', '<leader>]', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', '<leader>[', vim.lsp.buf.hover, opts)
          -- TODO: vim.lsp.buf.references(nil, {on_list = on_list})
          vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<leader>gD', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.signature_help, opts)

          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          -- NOTE: format file will strip whitespace first.
          -- this is because some fmt don't handle whitespace trim well.
          vim.keymap.set('n', '<leader>ff', function()
            vim.cmd('StripWhitespace')
            vim.lsp.buf.format { async = true }
            print('file formatted!')
          end, opts)
        end,
      })
    end,
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
    opts = {
      ensure_installed = {
        'clangd',
        'omnisharp',
        'rust_analyzer',
        'lua_ls',
        'pyright',
      },
      automatic_installation = false,
      automatic_enable = true,
    },
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- TODO: https://github.com/mfussenegger/nvim-lint
  -- TODO: https://github.com/neomake/neomake

  ------------------------------
  -- text editing
  ------------------------------

  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = '<leader>/'
      },
      opleader = {
        line = '<leader>/',
      }
    }
  },

  {
    'tpope/vim-surround',
    config = function()
      vim.keymap.set('x', 's', '<Plug>VSurround')
    end,
  },

  'vim-scripts/VisIncr',
  {
    'godlygeek/tabular',
    config = function()
      vim.cmd([[
        function! g:Tabular(ignore_range) range
          let c = getchar()
          let c = nr2char(c)
          if a:ignore_range == 0
            exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
          else
            exec printf('Tabularize /%s', c)
          endif
        endfunction
      ]])

      vim.keymap.set('n', '<leader>=', ':call g:Tabular(1)<CR>', { noremap = true, silent = true })
      vim.keymap.set('x', '<leader>=', ':call g:Tabular(0)<CR>', { noremap = true, silent = true })
    end,
  },

  -- DELME:
  {
    'jwu/vim-better-whitespace',
    init = function()
      vim.g.better_whitespace_guicolor = 'darkred'
      -- TODO: use the opt.list instead
      -- -- whitespace trail
      -- vim.opt.list = true
      -- vim.opt.listchars:append({ trail = '·' })
      -- vim.api.nvim_set_hl(0, 'NonText', { fg = '#FF0000' })
    end,
  },

  ------------------------------
  -- git operation
  ------------------------------

  'sindrets/diffview.nvim',

  ------------------------------
  -- language tools
  ------------------------------

  -- rust
  -- TODO:
  -- {
  --   'mrcjkb/rustaceanvim',
  --   version = '^4', -- Recommended
  --   ft = { 'rust' },
  -- }

})
