" Pi's vim config

" General settings
set nocompatible
set ttyfast                    " Faster redrawing
set lazyredraw                 " Only when necessary
set termguicolors              " More and better colors
set encoding=utf-8             " Unicode
set ignorecase                 " Search is case insensitive
set smartcase                  " Unless your search has capital letters
set mouse=a                    " Allow mouse integration
set backspace=indent,eol,start " Fix delete key
set showtabline=2              " Always show tabs
set cursorline                 " Highlight cursor line
set hidden                     " Can navigate through buffers even if they're not saved
set autoread                   " Re-read files if unmodified
set linebreak                  " Avoid wrapping lines in the middle of a word.
set number                     " Line numbers
set expandtab shiftround smartindent autoindent
set scrolloff=4                " Start scrolling when we're 8 lines away from margins
set sidescrolloff=10           " Same thing for side scrolling
set sidescroll=1
set noswapfile                 " Disable swap files (I like to live dangerously)
set nobackup
set nowb


" Plug config (Plugin list)
call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'pablopunk/native-sidebar.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'luochen1990/rainbow'
Plug 'sheerun/vim-polyglot'
Plug 'vhda/verilog_systemverilog.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'pablopunk/persistent-undo.vim'
Plug 'godlygeek/tabular'
Plug 'wincent/command-t'
Plug 'Raimondi/delimitMate'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'ycm-core/YouCompleteMe'
Plug 'flrnprz/candid.vim'
Plug 'lithammer/vim-eighties'

call plug#end()


" Command T binding
nmap <silent> <leader><t> <Plug>(CommandT)
nmap <silent> <C-p> <Plug>(CommandT)

" Remap leader key
let mapleader = "\<space>"

" Go to definition
nnoremap gd g]1<CR>

" Disable Ex Mode
nnoremap Q <Nop>

" Ctrl+c is ESC (it is by default but it won't trigger autocommands)
inoremap <c-c> <esc>

" Ctrl+s saves file in normal/insert mode
nnoremap <c-s> <esc>:w<CR>
inoremap <c-s> <esc>:w<CR>

" Ctrl-c copies in visual mode
vnoremap <c-c> "+y

" Ctrl+hjkl moves split focus
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Navigate through buffers
nnoremap gn :bn<cr>
nnoremap gb :bp<cr>
nnoremap <silent> <C-PageUp> :bn<cr>
nnoremap <silent> <C-PageDown> :bp<cr>
imap <silent> <C-PageUp> <C-o>:bn<cr>
imap <silent> <C-PageDown> <C-o>:bp<cr>

" Ctrl+t new tab
nnoremap <c-t> :tabe<cr>

" Ctrl+q close buffer
nnoremap <c-q> :bd<cr>

" Format file indentation
nnoremap <leader><Tab> <esc>gg=G``zz

" 0 goes to first indentation
nnoremap 0 ^

" Easier block indentation
nnoremap <tab> >>
nnoremap <s-tab> <<
vnoremap <tab> >gv
vnoremap <s-tab> <gv
nnoremap < <Nop>
vnoremap < <Nop>
nnoremap > <Nop>
vnoremap > <Nop>

" Disable weird command window when quickly pressing q: instead of :q
nnoremap q: :


" Better indent controls
function! InsertIndented()
    let l:line=getline('.')
    if (l:line=='')
        call feedkeys('ddO', 'n')
    else
        startinsert!
    endif
endfunction
nnoremap <silent> <S-a> :call InsertIndented()<CR>
inoremap {<CR> {<CR>}<C-o>O


" I don't wanna save changes to a directory
autocmd FileType netrw setl bufhidden=delete


" YCM
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" easytags / ctags
let g:easytags_autorecurse = 0
let g:easytags_async = 1

" tabline and themes
let g:airline#extensions#tabline#enabled = 1
set guifont="Source Code Pro for Powerline"
let g:airline_powerline_fonts = 1
let g:airline_theme="minimalist"

" Colors
syntax on
set background=dark
colorscheme eighties
"hi ErrorMsg ctermfg=White guifg=White
let g:rainbow_active = 1

" 80 cols
set colorcolumn=80
set textwidth=80
execute "set colorcolumn=" . join(range(81,400), ',')

" Command-T search config
let g:CommandTFileScanner = "find"
let g:CommandTMaxFiles = 250000
let g:CommandTSuppressMaxFilesWarning = 1

" Auto-nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Highlight trailing whitespace
highlight ExtraWhite ctermbg=darkred guibg=lightred
autocmd Syntax * syn match ExtraWhite /\s\+$/ containedin=ALL
autocmd colorscheme * highlight ExtraWhite ctermbg=darkred guibg=lightred

" No beeps plz
set visualbell

" Include local config
runtime local.vim

