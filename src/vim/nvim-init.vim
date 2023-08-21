"===================
"    Command Line
"===================
:cnoremap <C-a>  <Home>
:cnoremap <C-b>  <Left>
:cnoremap <C-f>  <Right>
:cnoremap <C-d>  <Delete>
:cnoremap <M-b>  <S-Left>
:cnoremap <M-f>  <S-Right>
:cnoremap <M-d>  <S-right><Delete>
:cnoremap <Esc>b <S-Left>
:cnoremap <Esc>f <S-Right>
:cnoremap <Esc>d <S-right><Delete>
:cnoremap <C-g>  <C-c>


"===================
"    Search
"===================
set incsearch
set ignorecase
set nohlsearch

"===================
"    Identation
"===================

" indents to the previous line
set autoindent

" load special indent files
filetype plugin indent on
filetype indent on

" set indent width
set tabstop=4
set shiftwidth=4
set expandtab



"=====================
"   Miscellaneous
"=====================

" Be iMproved
set nocompatible

" use system clipboard
set clipboard^=unnamed,unnamedplus

" put swap files in vim swap directory.
set directory=/Users/carlos.padilla/.vim/swap

" set persistent history.
set undodir=/Users/carlos.padilla/.config/nvim/undodir
set undofile

" briefly moves cursor to matching character
" and sets how long before it comes back
set showmatch
set mat=2

" set background for syntax coloring
set background=dark

" do not wrap lines
set nowrap

" show line numbers
set number

" show the current mode
set showmode

" show the commands as they are written
set showcmd

" show the position of the cursor
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

" force 256 colors for the command line version.
set t_Co=256

" keep at least this amount of lines before scrolling
set scrolloff=5

" do not backup files for cron
if $VIM_CRONTAB == "true"
	set nobackup
	set nowritebackup
endif

" window title
set title


"=====================
"   File Handling
"=====================

" updates flie automatically when they are changed outside
set autoread

" force writing of file
cmap w!! w !sudo tee % >/dev/null

" load filetype files
filetype plugin on


"==============
"   Editing
"==============

" set encoding
set encoding=utf8

" allows backspace to erase anything
set backspace=indent,eol,start

" allows direction keys to move up lines
set whichwrap+=<,>,h,l

" line height
set lsp=3

" allow insertion of a new line in normal mode
map <CR> i<CR><Esc>

nnoremap + /\$\w\+_<CR>
nnoremap _ :s/\v%(\$%(\k+))@<=_(\k)/\u\1/g<CR>

"=========================
"   Autocommands
"=========================

" set .as files to actionscript
au BufRead,BufNewFile *.as setlocal filetype=actionscript

" set .less files to css
au BufRead,BufNewFile *.less setlocal filetype=css
" compile less files on save
" au BufWritePost,FileWritePost *.less silent !lessc <afile> <afile>:r.css

" set .json files to javascript
au BufRead,BufNewFile *.json setlocal filetype=javascript

" YAML does not like tabs
au FileType yaml setlocal expandtab

" twig might as well be html
au BufRead,BufNewFile *.twig set filetype=html

" make js default to 2 char spacing
au BufRead,BufNewFile *.json setlocal shiftwidth=2 tabstop=2

" set GLSL highlighting
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl

" disable modelines for makefiles
au FileType make set modelines=0

" .tmux files
au BufRead,BufNewFile *.tmux set filetype=tmux

au BufNewFile,BufRead *.json set filetype=json

" make colorscheme also with in GUI
au BufRead,BufNewFile * colorscheme onedark
colorscheme onedark
"=============================== END custom =====================

let g:python3_host_prog='/usr/bin/python3'


"==============================
"    ControlP File Search
"==============================
nmap ; :CtrlPBuffer<CR>
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0

set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildmode=list:longest,list:full

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|vendor|node_modules)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

call plug#begin()

"Plug 'dense-analysis/ale' node high CPU
"Plug 'neomake/neomake' " alternative to ALE
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neovim/nvim-lspconfig'


" Coq.nvim Powered Autocomplete
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

" Coc.nvim Powered Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'yaegassy/coc-intelephense', {'do': 'yarn install --frozen-lockfile'}

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <Leader>g :CocDiagnostics<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Deno JS Powered Autocomplete
"Plug 'ervandew/supertab'
"Plug 'vim-denops/denops.vim' for Deno JS
"Plug 'Shougo/ddc.vim'
"Plug 'Shougo/ddc-ui-native'
"Plug 'Shougo/ddc-source-around'
"Plug 'Shougo/ddc-matcher_head'
"Plug 'Shougo/ddc-sorter_rank'

Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons' " icons in statusline

Plug 'gkjgh/cobalt'

Plug 'lukas-reineke/indent-blankline.nvim'

"Plug 'nvim-treesitter/nvim-treesitter'

" Guvbox theme
Plug 'ellisonleao/gruvbox.nvim'

call plug#end()


"======================================
"    Syntax Checking
"======================================
let g:neomake_open_list = 2
let g:neomake_php_enabled_makers = ['php', 'phpcs', 'phpstan']
let g:neomake_php_phpmd_maker = ''
"let g:neomake_php_maker = 'php', 'phpcs', 'phpstan']
"call neomake#configure#automake('nrwi', 100)


"======================================
"    Deno JS Powered Autocomplete
"======================================
"call ddc#custom#patch_global('ui', 'native')
"call ddc#custom#patch_global('sources', ['around'])
"call ddc#custom#patch_global('sourceOptions', {
"      \ '_': {
"      \   'matchers': ['matcher_head'],
"      \   'sorters': ['sorter_rank']},
"      \ })
"call ddc#custom#patch_global('sourceOptions', {
"      \ 'around': {'mark': 'A'},
"      \ })
"call ddc#custom#patch_global('sourceParams', {
"      \ 'around': {'maxSize': 500},
"      \ })

" Customize settings on a filetype
"call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])

"inoremap <silent><expr> <TAB> pumvisible() ? '<C-n>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
"inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

"call ddc#enable()


"======================================
"    Lua -- LSP
"======================================
let g:coq_settings = { 'auto_start': v:true, 'display.pum.fast_close': v:false }

lua <<EOF
--local lsp = require "lspconfig"
--local coq = require "coq"

--lsp.intelephense.setup(coq.lsp_ensure_capabilities({}))

--require("coq_3p") {
--  { src = "builtin/css"     },
--  { src = "builtin/html"    },
--  { src = "builtin/js"      },
--  { src = "builtin/php"     },
--}
EOF


"======================================
"    Lua -- Guvbox theme
"======================================

lua <<EOF
require('lualine').setup {
  options = {
    theme = 'gruvbox',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
  }
}
EOF
