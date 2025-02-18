"
" Pheo's ~/.config/nvim/init.vim (~/.nvimrc symlink)
" win32 @ ~/AppData/Local/nvim/init.vim
"

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

Plug 'folke/tokyonight.nvim'

" Plugins
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }

" rustup component add rust-analyzer
Plug 'mrcjkb/rustaceanvim'

Plug 'dense-analysis/ale'
Plug 'sbdchd/neoformat'
Plug 'chentoast/marks.nvim'

Plug 'github/copilot.vim'

" Telescope. remember to yay -S ripgrep
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
" or                                , { 'branch': '0.1.x' }

" CMP
" https://github.com/hrsh7th/nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

lua << END
require('nvim-tree').setup()
require('lualine').setup {
  sections = {
    lualine_c = {
      {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
      }
    }
  },
  inactive_sections = {
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 2
      }
    }
  }
}
END

" https://github.com/hrsh7th/nvim-cmp
set completeopt=menu,menuone,noselect
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })


  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    -- vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  end

  -- local lsp_flags = {
  --   -- This is the default in Nvim 0.7+
  --   debounce_text_changes = 150,
  -- }

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  --require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --  capabilities = capabilities
  --}
  require('lspconfig')['clangd'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
  }
  require('lspconfig')['pylsp'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
  }
  require('lspconfig')['ts_ls'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
  }
  require'marks'.setup {
    -- whether to map keybinds or not. default true
    default_mappings = true,
    -- which builtin marks to show. default {}
    builtin_marks = { ".", "<", ">", "^" },
    -- whether movements cycle back to the beginning/end of buffer. default true
    cyclic = true,
    -- whether the shada file is updated after modifying uppercase marks. default false
    force_write_shada = false,
    -- how often (in ms) to redraw signs/recompute mark positions. 
    -- higher values will have better performance but may cause visual lag, 
    -- while lower values may cause performance penalties. default 150.
    refresh_interval = 250,
    -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
    -- marks, and bookmarks.
    -- can be either a table with all/none of the keys, or a single number, in which case
    -- the priority applies to all marks.
    -- default 10.
    sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
    -- disables mark tracking for specific filetypes. default {}
    excluded_filetypes = {},
    -- disables mark tracking for specific buftypes. default {}
    excluded_buftypes = {},
    -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
    -- sign/virttext. Bookmarks can be used to group together positions and quickly move
    -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
    -- default virt_text is "".
    bookmark_0 = {
      sign = "⚑",
      virt_text = "hello world",
      -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
      -- defaults to false.
      annotate = false,
    },
    mappings = {}
  }

  require('telescope').setup{
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        }
      }
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
    },
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- }
      -- please take a look at the readme of the extension you want to configure
    },
    preview = {
      hide_on_startup = true -- hide previwer when picker starts
    }
  }
  vim.keymap.set('n', '<C-f>', ':Telescope<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-g>', ':NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-s>', ':mksession!<CR>', { noremap = true, silent = true })

  vim.keymap.set('n', '<C-_>', ':Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>ff', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', { noremap = true, silent = true })
  --vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fj', ':Telescope jumplist<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fm', ':Telescope marks<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fi', ':Telescope lsp_incoming_calls<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fo', ':Telescope lsp_outgoing_calls<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fe', ':Telescope lsp_implementations<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fd', ':Telescope lsp_definitions<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fr', ':Telescope lsp_references<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })

  local harpoon = require('harpoon')
  harpoon:setup({})


  vim.keymap.set("n", "<leader>ee", function() harpoon:list():add() end)
  -- vim.keymap.set("n", "<leader>fe", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  vim.keymap.set("n", "<leader>e1", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<leader>e2", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<leader>e3", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<leader>e4", function() harpoon:list():select(4) end)
  vim.keymap.set("n", "<leader>e5", function() harpoon:list():select(5) end)
  vim.keymap.set("n", "<leader>e6", function() harpoon:list():select(6) end)
  vim.keymap.set("n", "<leader>e7", function() harpoon:list():select(7) end)
  vim.keymap.set("n", "<leader>e8", function() harpoon:list():select(8) end)
  vim.keymap.set("n", "<leader>e9", function() harpoon:list():select(9) end)
  vim.keymap.set("n", "<leader>e0", function() harpoon:list():select(0) end)

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set("n", "<leader>ep", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<leader>en", function() harpoon:list():next() end)

  -- basic telescope configuration
  local function toggle_telescope(harpoon_files)
      local finder = function()
          local paths = {}
          for _, item in ipairs(harpoon_files.items) do
              table.insert(paths, item.value)
          end

          return require("telescope.finders").new_table({
              results = paths,
          })
      end

      require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = finder(),
          previewer = require("telescope.config").values.file_previewer({}),
          sorter = require("telescope.config").values.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
              map("i", "<C-d>", function()
                  local state = require("telescope.actions.state")
                  local selected_entry = state.get_selected_entry()
                  local current_picker = state.get_current_picker(prompt_bufnr)

                  table.remove(harpoon_files.items, selected_entry.index)
                  current_picker:refresh(finder())
              end)
              return true
          end,
      }):find()
  end

  vim.keymap.set("n", "<leader><Tab>", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open harpoon window" })

  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      disable = { "c", "rust" },
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
              return true
          end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    }
  }
EOF

" Shows in WM
set title

" Line Numbers
set number

" Highlight Syntax
syntax on

" Show non-\x20 chars (\t, &nbsp)
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

" Two-\x20 Indents & Tabs
set shiftwidth=2
set tabstop=2
set expandtab "uncomment for \t to \x20

" Treesitter fold
set foldmethod=expr "syntax if no treesitter
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

" Disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Cross-platform clipboard
set clipboard^=unnamed,unnamedplus
"set paste

" Color Scheme
colorscheme tokyonight

" Formatter (Neoformat)
let g:neoformat_run_all_formatters = 1

" Linter (Alt)
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_ruby_rubocop_options = '-D'
let b:ale_linters = ['eslint', 'rubocop']

au BufRead,BufNewFile *.csv set fileformat=dos
