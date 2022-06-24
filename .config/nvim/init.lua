----------- keybindings

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>n', ':nohlsearch<CR>')
vim.keymap.set('n', '<leader>-', ':s/^\\(\\s*- \\)\\(.*\\)$/\\1\\~\\~\\2\\~\\~/g <bar> :noh<cr>', {remap=false})
vim.keymap.set('n', '<leader><leader>-', ':s/\\~\\~//g <bar> :noh<cr>', {remap=false})

----------- plugins

-- install packer if not already installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- plugin list
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  use 'tpope/vim-surround'
  use 'easymotion/vim-easymotion'
  use 'tomtom/tcomment_vim'
  use 'github/copilot.vim'
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }

  -- Plugins can have dependencies on other plugins
  use {
    'haorenW1025/completion-nvim',
    opt = true,
    requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
  }

  -- Plugins can have post-install/update hooks
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate && TSInstall python' }

  -- Use dependency and run lua function after load
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function ()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
      vim.fn.sign_define("DiagnosticSignError",
      {text = " ", texthl = "DiagnosticSignError"})
      vim.fn.sign_define("DiagnosticSignWarn",
      {text = " ", texthl = "DiagnosticSignWarn"})
      vim.fn.sign_define("DiagnosticSignInfo",
      {text = " ", texthl = "DiagnosticSignInfo"})
      vim.fn.sign_define("DiagnosticSignHint",
      {text = "", texthl = "DiagnosticSignHint"})
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_by_name = {
              ".git",
            }
          }
        }
      })
    end

  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- plugin setup

-- telescope

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {"%.git/.*"}
  },
}

vim.cmd([[nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>]])
vim.cmd([[nnoremap <leader>fg <cmd>Telescope live_grep<cr>]])
vim.cmd([[nnoremap <leader>fb <cmd>Telescope buffers<cr>]])
vim.cmd([[nnoremap <leader>fh <cmd>Telescope help_tags<cr>]])

-- neo-tree

vim.cmd([[nnoremap \e :Neotree reveal<cr>]])
vim.cmd([[nnoremap \g :Neotree git_status<cr>]])

-- easymotion
vim.g.EasyMotion_smartcase = 1
vim.g.EasyMotion_use_smartsign_us = 1

-- bufferline
vim.opt.termguicolors = true
require("bufferline").setup{
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
}
vim.keymap.set('n', 'gt', ':BufferLineCycleNext<CR>', {remap = false})
vim.keymap.set('n', 'gT', ':BufferLineCyclePrev<CR>', {remap = false})

-- abbreviations

vim.cmd 'ab tday ###### Today'
vim.cmd 'ab yday ###### Yesterday'
vim.cmd 'ab wday ###### Wednesday'

-- settings

vim.opt.clipboard = 'unnamed'
vim.opt.shell = '/bin/zsh'
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.cmd 'set ignorecase smartcase'

--

