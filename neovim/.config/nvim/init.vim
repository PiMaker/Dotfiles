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
set shiftwidth=4
set scrolloff=4                " Start scrolling when we're 4 lines away from margins
set sidescrolloff=10           " Same thing for side scrolling
set sidescroll=1
set noswapfile                 " Disable swap files (I like to live dangerously)
set nobackup
set nowb
set updatetime=250             " Update stuff after 250ms (default 4000)
set visualbell                 " No beeps plz
set clipboard^=unnamedplus     " Use clipboard register (+) as default
"set list                      " Visualize tabs
"set listchars=tab:>\ 
set relativenumber             " Relative line numbers


" Plug config (Plugin list)
call plug#begin()

" Version control
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'

" Misc
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'xolox/vim-misc'
Plug 'haya14busa/incsearch.vim'
Plug 'pablopunk/persistent-undo.vim'
Plug 'can3p/incbool.vim'

" Code style
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
"Plug 'vivien/vim-linux-coding-style'

" Motions
Plug 'chaoren/vim-wordmotion'
Plug 'godlygeek/tabular'
Plug 'unblevable/quick-scope'
Plug 'kana/vim-textobj-user'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'glts/vim-textobj-comment'

" Styling
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'luochen1990/rainbow'
Plug 'lithammer/vim-eighties'

" Syntax/Autocomplete
Plug 'sheerun/vim-polyglot'
Plug 'vim-syntastic/syntastic'
Plug 'ycm-core/YouCompleteMe'
Plug 'xolox/vim-easytags'

" Languages
Plug 'vhda/verilog_systemverilog.vim'
Plug 'rust-lang/rust.vim'

" Tools
Plug 'wincent/command-t'
Plug 'jremmen/vim-ripgrep'

call plug#end()


" Remap leader key
let mapleader = "\<space>"

" Command T binding
nmap <silent> <leader><t> <Plug>(CommandT)
nmap <silent> <C-p> <Plug>(CommandT)

" Ripgrep (and repeating motions with ,)
noremap , ;
noremap ; :Rg<Space>

" Paragraph movement
noremap <S-k> {
noremap <S-j> }
noremap <S-Up> {
noremap <S-Down> }

" Nerdtree
map <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1

" Git messenger (<Leader>gm)
let g:git_messenger_always_into_popup=1

" Go to definition
nnoremap gd g]1<CR>

" Tagbar
nnoremap <F8> :TagbarToggle<CR> <bar> <c-w>l

" Disable Ex Mode
nnoremap Q <Nop>

" Substitute word under cursor shortcut
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" Ctrl+c is ESC (it is by default but it won't trigger autocommands)
inoremap <c-c> <esc>

" Ctrl+s saves file in normal/insert mode
nnoremap <c-s> <esc>:w<CR>
inoremap <c-s> <esc>:w<CR>

" Ctrl-c copies in visual mode
vnoremap <c-c> "+y

" Make <del> delete, not cut characters
noremap <del> "_x

" Alt-arrowkeys moves split focus
nnoremap <A-Left> <c-w>h
nnoremap <A-Down> <c-w>j
nnoremap <A-Up> <c-w>k
nnoremap <A-Right> <c-w>l

" Allow Ctrl-Left/Right to use vim-wordmotion plugin
nnoremap <C-Left> b
nnoremap <C-Right> w
inoremap <C-Left> <C-o>b
inoremap <C-Right> <C-o>w

" Navigate through buffers
nnoremap gn :bn<cr>
nnoremap gb :bp<cr>
nnoremap <silent> <C-PageUp> :bp<cr>
nnoremap <silent> <C-PageDown> :bn<cr>
imap <silent> <C-PageUp> <C-o>:bp<cr>
imap <silent> <C-PageDown> <C-o>:bn<cr>

" Ctrl+t new tab
nnoremap <c-t> :tabe<cr>

" (Ctrl|Alt)+q close buffer
nnoremap <c-q> :bd<cr>
nnoremap <a-q> :bd<cr>

" Format file indentation
nnoremap <leader><Tab> <esc>gg=G``zz

" 0 goes to first indentation
nnoremap 0 ^

" SyntasticCheck map for easy syntax test
nnoremap <F5> :SyntasticCheck<CR>
nnoremap <F6> :SyntasticReset<CR>

" Easier block indentation
nnoremap <tab> >>
nnoremap <s-tab> <<
vnoremap <tab> >gv
vnoremap <s-tab> <gv
nnoremap < <Nop>
vnoremap < <Nop>
nnoremap > <Nop>
vnoremap > <Nop>

" Scroll up/down without moving cursor
nnoremap <C-Up> <C-y>
inoremap <C-Up> <C-o><C-y>
nnoremap <C-Down> <C-e>
inoremap <C-Down> <C-o><C-e>
nnoremap <C-k> <C-y>
inoremap <C-k> <C-o><C-y>
nnoremap <C-j> <C-e>
inoremap <C-j> <C-o><C-e>

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

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


" Don't save changes to a directory
autocmd FileType netrw setl bufhidden=delete

" Gitgutter
autocmd BufWritePost * GitGutter
let g:gitgutter_sign_allow_clobber = 1
let g:gitgutter_preview_win_floating = 0

" YCM
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { "mode": "passive" }

let g:syntastic_perl_checkers = ['perl']
let g:syntastic_enable_perl_checker = 1

" easytags / ctags
let g:easytags_autorecurse = 0
let g:easytags_async = 1

" tabline and themes
let g:airline#extensions#tabline#enabled = 1
set guifont="Source Code Pro for Powerline"
let g:airline_powerline_fonts = 1
let g:airline_theme="minimalist"

" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

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

" Don't auto-insert comment header on newline, and don't auto-wrap long lines
au FileType * set fo-=r fo-=o fo+=l

" Command-T search config
let g:CommandTFileScanner = "find"
let g:CommandTMaxFiles = 250000
let g:CommandTSuppressMaxFilesWarning = 1

" Auto-nohlsearch
set hlsearch
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" Required for autoread
au CursorHold * checktime
au FocusGained,BufEnter * :silent! !

" Highlight trailing whitespace
highlight ExtraWhite ctermbg=darkred guibg=lightred
autocmd Syntax * syn match ExtraWhite /\s\+$/ containedin=ALL
autocmd colorscheme * highlight ExtraWhite ctermbg=darkred guibg=lightred

" Include local config
runtime local.vim

