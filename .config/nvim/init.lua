-- vim.cmd 'set clipboard=unnamedplus'
vim.opt.clipboard:append("unnamedplus")
vim.opt.shell = '/bin/zsh'
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
----------- plugins
-- _G.__luacache_config = {
--   chunks = {
--     enable = true,
--     path = vim.fn.stdpath('cache') .. '/luacache_chunks',
--   },
--   modpaths = {
--     enable = true,
--     path = vim.fn.stdpath('cache') .. '/luacache_modpaths',
--   }
-- }
-- require('impatient')

-- install packer if not already installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' --package manager
  use 'lewis6991/impatient.nvim' -- plugin optimization
  use "folke/neodev.nvim"
  use 'mfussenegger/nvim-dap' -- debugger
  use 'mfussenegger/nvim-dap-python'
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
  use 'theHamsta/nvim-dap-virtual-text'
  use {
    'lewis6991/gitsigns.nvim', -- git gutter
    -- tag = 'release',
    config = function()
      require('gitsigns').setup()
    end,
  }
  use 'williamboman/nvim-lsp-installer' -- lsp ls installer
  use 'neovim/nvim-lspconfig' -- lsp
  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  }
  use 'tpope/vim-surround'
  use 'easymotion/vim-easymotion'
  use 'tomtom/tcomment_vim'
  -- use {
  --   'github/copilot.vim',
  --   config = function()
  --     vim.cmd 'imap <silent><script><expr> <C-L> copilot#Accept()'
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_tab_fallback = ""
  --     vim.g["copilot_filetypes"] = { gitcommit = true }  -- TODO fix; broken for now.
  --     vim.g.copilot_proxy = 'localhost:8118'
  --   end,
  -- }
  use 'famiu/bufdelete.nvim' -- a minimal plugin to provide a better buffer delete command
  use {
    "goolord/alpha-nvim", -- greeter
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  use { 'nvim-treesitter/nvim-treesitter' } -- language parser

  use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' } -- nice tabs instead of buffers

  -- use 'navarasu/onedark.nvim' -- theme manager
  use "olimorris/onedarkpro.nvim"
  use {
    'kyazdani42/nvim-tree.lua', -- file manager
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    tag = 'nightly'
  }
  use {
    'nvim-telescope/telescope.nvim', -- like fzf.vim but better
    requires = { 'nvim-lua/plenary.nvim', }
  }
  use 'nvim-telescope/telescope-project.nvim' -- project manager plugin for telescope
  use { 'nvim-lualine/lualine.nvim' } -- statusbar
  use {
    "folke/which-key.nvim", -- keybindings manager
    config = function()
      require("which-key").setup {}
    end
  }
  use {
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = function()
      require("toggleterm").setup {
        open_mapping = [[<C-\>]],
        insert_mappings = true,
        start_in_insert = true,
        close_on_exit = true,
      }
    end
  }

  -- cmp
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
end)

-- plugin setup

-- Which-key
local wk = require('which-key')

vim.g.mapleader = ' '

wk.register({
  R = { '<cmd>luafile ~/.config/nvim/init.lua<CR>', "Reload init.lua" },
  ['<C-s>'] = { '<cmd>w<CR>', "Save buffer" }
})
-- wk.register({
--   ['<A-n>'] = { '<C-x><C-o>', "Trigger Autocomplete" }
-- }, { mode = 'i', nowait = true })

vim.cmd 'noremap! <C-BS> <C-w>'
vim.cmd 'noremap! <C-h> <C-w>'
vim.keymap.set('i', '<ESC>', '<ESC><ESC>', { noremap = true })

wk.register({
  n = { ':nohlsearch<CR>', "nohlsearch" },
  ['-'] = { ':s/^\\(\\s*- \\)\\(.*\\)$/\\1\\~\\~\\2\\~\\~/g <bar> :noh<cr>' },
  ['<leader>-'] = { ':s/\\~\\~//g <bar> :noh<cr>' }
}, { prefix = "<leader>" })

-- neodev

require('neodev').setup({})

-- dap
local dap = require('dap')
local dap_widgets = require('dap.ui.widgets')
vim.fn.sign_define('DapBreakpoint', { text = '⭕️', texthl = '', linehl = '', numhl = '' })

wk.register({
  ['<S-J>'] = { dap.step_over, 'Step Over' },
  ['<S-L>'] = { dap.step_into, 'Step Into' },
  ['<S-H>'] = { dap.step_out, 'Step Out' },
})
wk.register({
  ['c'] = { dap.continue, 'Continue' },
  ['u'] = { dap.up, 'Up' },
  ['d'] = { dap.down, 'Down' },
  ['t'] = { dap.terminate, 'Terminate' },
  ['h'] = { dap_widgets.hover, 'Hover' },
  ['b'] = { dap.toggle_breakpoint, 'Toggle Breakpoint' },
  ['\\'] = { dap.repl.toggle, 'Repl' },
  ['r'] = { dap.run_last, 'Run Last' },
}, { prefix = '<leader>d' })

-- dap-py
local dapy = require('dap-python')
dapy.setup()
dap.configurations.python = {
  {
    name = 'Python 3',
    type = 'python',
    request = 'launch',
    program = '${file}',
    justMyCode = false,
  },
  {
    name = 'Django',
    type = 'python',
    request = 'launch',
    program = vim.fn.getcwd() .. '/manage.py', -- NOTE: Adapt path to manage.py as needed
    args = { 'runserver', '--noreload' },
    justMyCode = false,
  },
  {
    name='Django (Attach)',
    type='python',
    request='attach',
    port=5000,
    justMyCode = false,
  },
}
-- require('dap.ext.vscode').load_launchjs()

wk.register({
  ['pm'] = { dapy.test_method, "Test above method" },
  ['pc'] = { dapy.test_class, "Test above class" },
}, { prefix = '<leader>d' })

wk.register({
  ['ps'] = { dapy.test_selection, "Test selection" },
}, { prefix = '<leader>d', mode = 'v' })

-- dap-ui
local dapui = require("dapui")
dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
      },
      size = 40,
      position = "right",
    },
    -- {
    --   elements = {
    --     "repl",
    --   },
    --   size = 0.25,
    --   position = "bottom",
    -- }
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  }
})
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
wk.register({
  e = { dapui.eval, "Evaluate Expression" },
}, { prefix = '<leader>d', mode = 'v' })

-- dap-virtualtext
require('nvim-dap-virtual-text').setup()

-- treesitter
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua", "yaml", "json" },

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    additional_vim_regex_highlighting = false,
  },
}

-- CMP
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- vim.opt.completeopt = 'menu,menuone,noselect'
vim.cmd 'set completeopt=menu,menuone,noselect'
local cmp = require 'cmp'
cmp.setup({
  snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<Esc>'] = cmp.mapping.abort(),
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   local copilot_keys = vim.fn["copilot#Accept"]("")
    --   if cmp.visible() then
    --     return cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
    --   elseif copilot_keys ~= "" then
    --     vim.api.nvim_feedkeys(copilot_keys, "i", false)
    --   else
    --     fallback()
    --   end
    -- end),
    ["<A-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      end
    end, { "i", "s", "c", }),

    ["<A-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),

  sources = { { name = "nvim_lsp" }, { name = "nvim_lua" }, { name = "buffer" }, { name = "path" }, { name = 'emoji' } },
  completion = {
    autocomplete = false
  }
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- LSP
wk.register({
  ['h'] = { vim.diagnostic.open_float, "LSP hover" },
  ['l'] = { vim.diagnostic.goto_prev, "Last LSP message" },
  ['q'] = { vim.diagnostic.setloclist, "LSP messages" },
}, { prefix = '<leader>l' })

local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  wk.register({
    ['gd'] = { vim.lsp.buf.definition, "Go to the definition" },
    ['gD'] = { vim.lsp.buf.type_definition, "Show Type" },
    ['gr'] = { vim.lsp.buf.references, "References" },
    ['gh'] = { vim.lsp.buf.hover, "Show hover" },
    ['<F2>'] = { vim.lsp.buf.rename, "Rename" },
    ['<leader>f'] = { '<cmd>lua vim.lsp.buf.format({ async=true, timeout_ms=5000 })<CR>', "Format Document" },
    -- ['gD'] = { vim.lsp.buf.declaration, "Go to the decleration" },
    -- ['gI'] = { vim.lsp.buf.implementation, "Show Impl." },
    -- ['gS'] = { vim.lsp.buf.signature_help, "Show Signature" },
    -- ['<leader>ca'] = { vim.lsp.buf.code_action, "Code Action" },
  }, { buffer = bufnr })
end

require('nvim-lsp-installer').setup({
  automatic_installation = true,
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

local lsp_util = require('lspconfig/util')

require('lspconfig')['pyright'].setup {
  on_attach = on_attach,
  root_dir = function(fname)
    return lsp_util.root_pattern(".git", "pyproject.toml", "requirements.txt")(fname) or lsp_util.path.dirname(fname)
  end,
  before_init = function(_, config)
    local path
    if vim.env.VIRTUAL_ENV then
      path = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
    else
      path = lsp_util.find_cmd("python3", ".venv/bin", config.root_dir)
    end
    vim.api.nvim_echo('python3: ' .. path)
    config.settings.python.pythonPath = path
  end,
  capabilities = cmp_capabilities,
  settings = {
    python = { analysis = { typeCheckingMode = "off" } }
  }
}
require('lspconfig')['lua_ls'].setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'packer_bootstrap' }
      }
    }
  },
  capabilities = cmp_capabilities,
}

-- null-ls
local null_ls = require('null-ls')
local sources = {
  null_ls.builtins.diagnostics.mypy.with({
    prefer_local = "./.venv/bin",
    extra_args = { "--ignore-missing-imports"},-- "--follow-imports=silent" },
    -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE
  }),
  null_ls.builtins.diagnostics.flake8.with({
    prefer_local = "./.venv/bin",
  }),
  null_ls.builtins.formatting.black.with({
    prefer_local = "./.venv/bin",
    extra_args = { "--preview" },
  }),
}
null_ls.setup({ sources = sources, diagnostics_format = "[#{c}] #{m} (#{s})", })

-- telescope
local telescope = require('telescope')
telescope.setup {
  defaults = {
    file_ignore_patterns = { "%.git/.*", "%.venv/.*" },
    vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
      "--smart-case", "--hidden", "--ignore" }
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--ignore", "--hidden", "--files" }
    },
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        }
      }
    }
  }
}
telescope.load_extension('project')

local telescope_builtin = require('telescope.builtin')
wk.register({
  ['<C-p>'] = { telescope_builtin.find_files, "Open File" },
  ['<C-k><C-o>'] = { '<cmd>Telescope project<cr>', "Projects" },
})
wk.register({
  o = { telescope_builtin.treesitter, 'Symbols in File' },
  p = { telescope_builtin.lsp_dynamic_workspace_symbols, 'Symbols in Workspace' },
  r = { telescope_builtin.lsp_references, 'References' },
  l = { telescope_builtin.diagnostics, 'LSP Diagnostics' },
  gst = { telescope_builtin.git_status, 'Git Status' },
  gc = { telescope_builtin.git_commits, 'Git Commits' },
  gb = { telescope_builtin.git_branches, 'Git Branches' },
  gsta = { telescope_builtin.git_stash, 'Git Stash' },
  f = { telescope_builtin.live_grep, 'Live Grep' },
  b = { telescope_builtin.buffers, 'Buffers' },
  h = { telescope_builtin.help_tags, 'Help Tags' },
}, { prefix = '<leader>t' })

-- nvim-tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
      },
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      git_placement = "after",
      glyphs = {
        git = {
          unstaged = "M",
        }
      }
    }
  },
  filters = {
    dotfiles = false,
    custom = {
      "^\\.git",
      "^\\.venv",
    },
  },
})

wk.register({
  ['\\e'] = { '<cmd>NvimTreeToggle<cr>', "Toggle Tree" },
})

-- easymotion
vim.g.EasyMotion_smartcase = 1
vim.g.EasyMotion_use_smartsign_us = 1

-- bufferline
vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
}
wk.register({
  -- ['gt'] = { '<cmd>BufferLineCycleNext<CR>', "Next Buffer" },
  -- ['gT'] = { '<cmd>BufferLineCyclePrev<CR>', "Prev Buffer" },
  ['<leader>bmt'] = { '<cmd>BufferLineMoveNext<CR>', "Move Buffer Forward" },
  ['<leader>bmT'] = { '<cmd>BufferLineMovePrev<CR>', "Move Buffer Backward" },
  ['<leader>bd'] = { '<cmd>BufferLinePickClose<CR>', "Pick Close Buffer" },
  ['<leader>bp'] = { '<cmd>BufferLinePick<CR>', "Goto Buffer" },
})

-- alpha
local db = require('alpha.themes.dashboard')
db.section.header.val = {
  [[                               __                ]],
  [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}
db.section.buttons.val = {
  db.button("<C-p>", "  Find file", ":Telescope find_files <CR>"),
  db.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
  db.button("p", "  Find project", ":Telescope projects <CR>"),
  db.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
  db.button("<leader>tf", "  Find text", ":Telescope live_grep <CR>"),
  db.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  db.button("q", "  Quit Neovim", ":qa<CR>"),
}
db.section.header.opts.hl = "Include"
db.section.buttons.opts.hl = "Keyword"

db.opts.opts.noautocmd = false
require('alpha').setup(db.opts)

local function get_listed_buffers()
  local buffers = {}
  local len = 0
  for buffer = 1, vim.fn.bufnr('$') do
    if vim.fn.buflisted(buffer) == 1 then
      len = len + 1
      buffers[len] = buffer
    end
  end

  return buffers
end

local alpha_start = function()
  local buffers = get_listed_buffers()
  local len = #buffers
  if len == 0 then
    require('alpha').start()
  end
end
alpha_start()

vim.api.nvim_create_augroup('alpha_on_empty', { clear = true })
vim.api.nvim_create_autocmd('User', {
  pattern = 'BDeletePre',
  group = 'alpha_on_empty',
  callback = function(event)
    local found_non_empty_buffer = false
    local buffers = get_listed_buffers()

    for _, bufnr in ipairs(buffers) do
      if not found_non_empty_buffer then
        local name = vim.api.nvim_buf_get_name(bufnr)
        local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

        if bufnr ~= event.buf and name ~= '' and ft ~= 'Alpha' then
          found_non_empty_buffer = true
        end
      end
    end

    if not found_non_empty_buffer then
      -- require('nvim-tree').toggle(true, false)
      vim.cmd [[:Alpha]]
    end
  end,
})

wk.register({ ["<leader>c"] = { "<cmd>Bdelete<CR>", "Close buffer" }, })

-- OneDark Theme

require("onedarkpro").setup({
  theme = "onedark", -- The default dark theme
  plugins = {}, -- all are enabled
  styles = { -- Choose from "bold,italic,underline"
    --   types = "italic", -- Style that is applied to types
    --   numbers = "NONE", -- Style that is applied to numbers
    --   strings = "NONE", -- Style that is applied to strings
    --   comments = "NONE", -- Style that is applied to comments
    --   keywords = "NONE", -- Style that is applied to keywords
    --   constants = "NONE", -- Style that is applied to constants
    --   functions = "NONE", -- Style that is applied to functions
    --   operators = "NONE", -- Style that is applied to operators
    --   variables = "NONE", -- Style that is applied to variables
    --   conditionals = "NONE", -- Style that is applied to conditionals
    --   virtual_text = "NONE", -- Style that is applied to virtual text
  },
  options = {
    bold = true, -- Use bold styles?
    italic = true, -- Use italic styles?
    underline = true, -- Use underline styles?
    undercurl = true, -- Use undercurl styles?

    cursorline = false, -- Use cursorline highlighting?
    transparency = false, -- Use a transparent background?
    terminal_colors = false, -- Use the theme's colors for Neovim's :terminal?
    window_unfocused_color = false, -- When the window is out of focus, change the normal background?
  }
})

-- require('onedark').setup {
--   style = 'warmer',
--   transparent = false,
--   term_colors = true,
--   ending_tildes = false,
--   cmp_itemkind_reverse = false,
--   code_style = {
--     comments = 'italic',
--     keywords = 'none',
--     functions = 'none',
--     strings = 'none',
--     variables = 'none'
--   },
--   diagnostics = {
--     darker = true,
--     undercurl = true,
--     background = true,
--   },
-- }
-- require('onedark').load()
if not vim.g.vscode then
vim.cmd('colorscheme onedark')
else
  vim.cmd.colorscheme = ""
end
-- vim.cmd('colorscheme onedark')

-- Lualine
require('lualine').setup {
  options = {
    theme = 'onedark',
    disabled_filetypes = { 'NvimTree', 'gitcommit' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { dap.status, 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
}


-------- abbreviations

vim.cmd 'ab tday ###### Today'
vim.cmd 'ab yday ###### Yesterday'
vim.cmd 'ab wday ###### Wednesday'

-------- settings

vim.cmd 'set ignorecase smartcase'
vim.cmd 'set colorcolumn=79'
vim.cmd 'highlight ColorColumn ctermbg=lightgrey guibg=lightgrey'

-- number toggling
vim.cmd 'set number'

vim.cmd ':augroup numbertoggle'
vim.cmd ':autocmd!'
vim.cmd ':autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif'
vim.cmd ':autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif'
vim.cmd ':augroup END'

--
