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
set title                      " Change terminal title
set history=1000               " Remember more commands and search history
set undolevels=1000            " Remember more undos
set gdefault                   " Automatically add /g behind regex substitutions
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
Plug 'christianrondeau/vim-base64'

" Code style
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
"Plug 'vivien/vim-linux-coding-style'

" Motions
Plug 'chaoren/vim-wordmotion'
Plug 'unblevable/quick-scope'
Plug 'justinmk/vim-sneak'
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
Plug 'xolox/vim-easytags'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'fszymanski/deoplete-emoji'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'mvgrimes/vim-trackperlvars'

" Tools
Plug 'junegunn/fzf'
Plug 'jremmen/vim-ripgrep'

" Load icons last
Plug 'ryanoasis/vim-devicons'

call plug#end()


" Load external scripts
source $HOME/.config/nvim/fzf-preview.vim
source $HOME/.config/nvim/incbool.vim


" Remap leader key
let mapleader = "\<space>"

" Ripgrep (and repeating motions with ,)
nnoremap , ;
nnoremap ; :Rg<Space>

" Commentary
nnoremap <CR> :Commentary<CR>
xnoremap <CR> :Commentary<CR>

" Paragraph movement
noremap <S-k> {
noremap <S-j> }
noremap <S-Up> {
noremap <S-Down> }

" Make j/k behave on long wrapped lines
nnoremap j gj
nnoremap k gk

" Better regex searches
nnoremap / /\v
vnoremap / /\v

" Nerdtree
map <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize=32
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1

" Git messenger (<Leader>gm)
let g:git_messenger_always_into_popup=1

" Go to definition
nnoremap gd g]1<CR><CR>

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
xnoremap <c-s> <esc>:w<CR>

" Ctrl-(shift)-c copies in visual mode
" It does via the "remote-clip.sh" script, thus also allowing copy over SSH
xnoremap <c-c> :w !~/.config/nvim/remote-clip.sh<CR><CR>
xnoremap <c-s-c> :w !~/.config/nvim/remote-clip.sh<CR><CR>

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

" Easier block indentation
nnoremap <tab> >>
nnoremap <s-tab> <<
xnoremap <tab> >gv
xnoremap <s-tab> <gv
nnoremap < <Nop>
xnoremap < <Nop>
nnoremap > <Nop>
xnoremap > <Nop>

" Reverse-indent with Shift-TAB
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-d>

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
xnoremap <A-j> :m '>+1<CR>gv=gv
xnoremap <A-k> :m '<-2<CR>gv=gv

" GitGutter hunk movement
nmap <Leader>hn <Plug>(GitGutterNextHunk)
nmap <Leader>hN <Plug>(GitGutterPrevHunk)

" LanguageClient
nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" Disable weird command window when quickly pressing q: instead of :q
nnoremap q: :
" but still allow quick exit from Macro recording mode
nnoremap Q q


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

" Format JSON with Python's help
com! FormatJSON %!python -m json.tool

" vim-cutlass, but better and DIY
nnoremap c "_c
nnoremap cc "_S
nnoremap C "_C
nnoremap X "_dd
nnoremap x "_d1<Right>
xnoremap p "_dP


" Don't save changes to a directory
autocmd FileType netrw setl bufhidden=delete

" Unmap enter key in quickfix windows to allow default plugin behaviour
" (Fixes vim-ripgrep)
autocmd BufWinEnter quickfix map <buffer> <CR> <CR>

" sneak
let g:sneak#label = 1
let g:sneak#s_next = 0
let g:sneak#use_ic_scs = 1

" Easytags
let g:easytags_async = 1

" Gitgutter
autocmd BufWritePost * GitGutter
let g:gitgutter_sign_allow_clobber = 1
let g:gitgutter_preview_win_floating = 0

" Deoplete
let g:deoplete#enable_at_startup = 1
autocmd CompleteDone * silent! pclose!
call deoplete#custom#source('emoji', 'converters', ['converter_emoji'])
set pumheight=16

" Make it <TAB> completion
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
inoremap <silent><expr> <S-TAB>
      \ pumvisible() ? "\<C-p>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()

inoremap <silent><expr> <Down>
      \ pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <silent><expr> <Up>
      \ pumvisible() ? "\<C-p>" : "\<Up>"

" Fix <CR> behaviour
function! s:cr_function()
    if pumvisible()
        if empty(v:completed_item)
            " Quickly select and unselect first element to work around weirdness
            " with \n sometimes not doing what it's supposed to
            return "\<C-n>\<C-p>\n"
        else
            return deoplete#close_popup()
        endif
    else
        return "\n"
    endif
endfunction
inoremap <silent> <CR> <C-r>=<SID>cr_function()<CR>

" LanguageClient
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'go': ['gopls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ }
    " \ 'perl': ['perl', '-MPerl::LanguageServer', '-e',
    " \     'Perl::LanguageServer::run', '--',
    " \     '--port', '13603', '--log-level', '0'],

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
au FocusGained,BufEnter * :silent! !

" Highlight trailing whitespace
highlight ExtraWhite ctermbg=darkred guibg=lightred
autocmd Syntax * syn match ExtraWhite /\s\+$/ containedin=ALL
autocmd colorscheme * highlight ExtraWhite ctermbg=darkred guibg=lightred

" Autosave on buffer leave
au FocusLost * :wa

" Include local config
runtime local.vim

