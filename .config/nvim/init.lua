----------- plugins
_G.__luacache_config = {
  chunks = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/luacache_chunks',
  },
  modpaths = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/luacache_modpaths',
  }
}
require('impatient')

-- install packer if not already installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

-- plugin list
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- end)
  use 'lewis6991/impatient.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    tag = 'release',
    config = function()
      require('gitsigns').setup()
    end,
  }
  use 'williamboman/nvim-lsp-installer'
  use 'neovim/nvim-lspconfig'
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
  use 'github/copilot.vim'
  use 'famiu/bufdelete.nvim'
  use {
    "goolord/alpha-nvim",
    requires = { 'kyazdani42/nvim-web-devicons' },
  }
  -- use {
  --   'w0rp/ale',
  --   ft = { 'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex' },
  --   cmd = 'ALEEnable',
  --   config = 'vim.cmd[[ALEEnable]]'
  -- }

  -- use {
  --   'haorenW1025/completion-nvim',
  --   opt = true,
  --   requires = { { 'hrsh7th/vim-vsnip', opt = true }, { 'hrsh7th/vim-vsnip-integ', opt = true } }
  -- }

  -- use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' }

  use { 'nvim-treesitter/nvim-treesitter' }

  use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }

  use 'navarasu/onedark.nvim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    tag = 'nightly'
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim', }
  }
  use 'nvim-telescope/telescope-project.nvim'
  use { 'nvim-lualine/lualine.nvim' }
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end
  }
  use {
    "akinsho/toggleterm.nvim",
    tag = 'v1.*',
    config = function()
      require("toggleterm").setup {
        open_mapping = [[<C-\>]],
        insert_mappings = true,
        start_in_insert = true,
        close_on_exit = true,
      }
    end
  }
  use { 'Shatur/neovim-session-manager', requires = { 'nvim-lua/plenary.nvim' } }
end)

-- plugin setup

-- Which-key
local wk = require('which-key')

vim.g.mapleader = ' '

wk.register({
  R = { '<cmd>luafile ~/.config/nvim/init.lua<CR>', "Reload init.lua" },
  ['<C-s>'] = { '<cmd>w<CR>', "Save buffer" }
})

wk.register({
  n = { ':nohlsearch<CR>', "nohlsearch" },
  ['-'] = { ':s/^\\(\\s*- \\)\\(.*\\)$/\\1\\~\\~\\2\\~\\~/g <bar> :noh<cr>' },
  ['<leader>-'] = { ':s/\\~\\~//g <bar> :noh<cr>' }
}, { prefix = "<leader>" })


-- session-manager
local Path = require('plenary.path')
require('session_manager').setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
  path_replacer = '__', -- The character to which the path separator will be replaced for session files.
  colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
  autoload_mode = require('session_manager.config').AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true, -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
    'gitcommit',
  },
  autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
})

-- LSP
wk.register({
  ['dh'] = { vim.diagnostic.open_float, "Diag hover" },
  ['dl'] = { vim.diagnostic.goto_prev, "Last Diag message" },
  ['dq'] = { vim.diagnostic.setloclist, "Diag messages" },
}, { prefix = '<leader>' })

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  wk.register({
    ['gD'] = { vim.lsp.buf.declaration, "Go to the decleration" },
    ['gd'] = { vim.lsp.buf.definition, "Go to the definition" },
    ['gh'] = { vim.lsp.buf.hover, "Show hover" },
    ['gI'] = { vim.lsp.buf.implementation, "Show Impl." },
    ['gS'] = { vim.lsp.buf.signature_help, "Show Signature" },
    ['<leader>D'] = { vim.lsp.buf.type_definition, "Show Type" },
    ['<leader>rn'] = { vim.lsp.buf.rename, "Rename" },
    ['<leader>ca'] = { vim.lsp.buf.code_action, "Code Action" },
    ['gr'] = { vim.lsp.buf.references, "References" },
    ['<leader>f'] = { '<cmd>lua vim.lsp.buf.format({ async=true, timeout_ms=5000 })<CR>', "Format Document" },
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
  -- before_init = function(_, config)
  --   local path
  --   if vim.env.VIRTUAL_ENV then
  --       path = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
  --   else
  --       path = lsp_util.find_cmd("python3", ".venv/bin", config.root_dir)
  --   end
  --   config.settings.python.pythonPath = path
  -- end,
}
require('lspconfig')['sumneko_lua'].setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}
require('null-ls').setup {
  sources = {
    require('null-ls').builtins.diagnostics.flake8,
    require('null-ls').builtins.formatting.black,
  }
}

-- telescope
local telescope = require('telescope')
telescope.setup {
  defaults = {
    file_ignore_patterns = { "%.git/.*" },
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
  gs = { telescope_builtin.git_status, 'Git Status' },
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
  ['gt'] = { '<cmd>BufferLineCycleNext<CR>', "Next Buffer" },
  ['gT'] = { '<cmd>BufferLineCyclePrev<CR>', "Prev Buffer" },
  ['<leader>bd'] = { '<cmd>BufferLinePickClose<CR>', "Pick Close Buffer" },
  ['<leader>bp'] = { '<cmd>BufferLinePick<CR>', "Goto Buffer" },
})

-- OneDark Theme

require('onedark').setup {
  style = 'warmer',
  transparent = true,
  term_colors = true,
  ending_tildes = false,
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
  code_style = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none'
  },

  -- Plugins Config --
  diagnostics = {
    darker = true,
    undercurl = true,
    background = true,
  },
}
require('onedark').load()

-- Lualine

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    always_divide_middle = true,
    globalstatus = false,
    disabled_filetypes = { 'NvimTree', 'gitcommit' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
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
  tabline = {},
  extensions = {}
}

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
  db.button("<leader>fg", "  Find text", ":Telescope live_grep <CR>"),
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
      require('nvim-tree').toggle(true, false)
      vim.cmd [[:Alpha]]
    end
  end,
})

wk.register({ ["<leader>c"] = { "<cmd>Bdelete<CR>", "Close buffer" }, })

-------- abbreviations

vim.cmd 'ab tday ###### Today'
vim.cmd 'ab yday ###### Yesterday'
vim.cmd 'ab wday ###### Wednesday'

-------- settings

vim.opt.clipboard = 'unnamed'
vim.opt.shell = '/bin/zsh'
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.cmd 'set ignorecase smartcase'

-- number toggling
vim.cmd 'set number'

vim.cmd ':augroup numbertoggle'
vim.cmd ':autocmd!'
vim.cmd ':autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif'
vim.cmd ':autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif'
vim.cmd ':augroup END'

--
