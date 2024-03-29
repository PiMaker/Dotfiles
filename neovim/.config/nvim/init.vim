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
set tabstop=4
set scrolloff=4                " Start scrolling when we're 4 lines away from margins
set sidescrolloff=10           " Same thing for side scrolling
set sidescroll=1
set noswapfile                 " Disable swap files (I like to live dangerously)
set nobackup
set nowb
set updatetime=250             " Update stuff after 250ms (default 4000)
set visualbell                 " No beeps plz
set title                      " Change terminal title
set history=1000               " Remember more commands and search history
set undolevels=1000            " Remember more undos
set gdefault                   " Automatically add /g behind regex substitutions
"set list                      " Visualize tabs
"set listchars=tab:>\ 
set relativenumber             " Relative line numbers
set list
set nofixendofline

" Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.config/nvim/undo

let wsl_compat=0
if has('wsl')
      let wsl_compat=1
elseif $WSL_COMPAT == "1"
      let wsl_compat=1
endif

if !wsl_compat
      set clipboard^=unnamedplus     " Use clipboard register (+) as default
endif

" Plug config (Plugin list)
call plug#begin()

" Version control
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
Plug 'simnalamburt/vim-mundo'

" Misc
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'xolox/vim-misc'
Plug 'haya14busa/incsearch.vim'
Plug 'pablopunk/persistent-undo.vim'
Plug 'christianrondeau/vim-base64'
Plug 'farmergreg/vim-lastplace'
if !has('wsl')
      Plug 'ojroques/vim-oscyank'
endif

" Code style
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
"Plug 'rstacruz/vim-closer'
"Plug 'vivien/vim-linux-coding-style'

" Motions
Plug 'chaoren/vim-wordmotion'
Plug 'unblevable/quick-scope'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-user'
Plug 'wellle/targets.vim'

" Styling
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'baopham/vim-nerdtree-unfocus'
Plug 'luochen1990/rainbow'
Plug 'lithammer/vim-eighties'
Plug 'Xuyuanp/scrollbar.nvim'

" Syntax/Autocomplete
Plug 'sheerun/vim-polyglot'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Extensions to built-in LSP, for example, providing type inlay hints
" Plug 'tjdevries/lsp_extensions.nvim'
" Autocompletion framework for built-in LSP
" Plug 'nvim-lua/completion-nvim'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

" Plug 'ludovicchabant/vim-gutentags'

" Tools
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'chengzeyi/fzf-preview.vim'
Plug 'jremmen/vim-ripgrep'

Plug 'github/copilot.vim'

" Load icons last
Plug 'ryanoasis/vim-devicons'

call plug#end()


" Load external scripts
source $HOME/.config/nvim/incbool.vim
source $HOME/.config/nvim/starsearch.vim


" Remap leader key
let mapleader = "\<space>"

" Disable Copilot by default
let g:copilot_enabled = 1

" FZF (+preview) binding
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs'
nmap <silent> <C-p> :FZFFiles<CR>
nmap <silent> <C-l> :FZFTags<CR>

" Ripgrep (and repeating motions with ,)
nnoremap , ;
nnoremap ; :FZFRg<CR>

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

" Git messenger (<Leader>gm)
let g:git_messenger_always_into_popup=1

" Go to definition
nnoremap <silent> gd g]

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
nmap <Leader>hm /^\<\<\<\<\<\<\< HEAD<CR>

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

" Undo Tree
nnoremap <F4> :MundoToggle<CR>
let g:mundo_width = 70
let g:mundo_preview_height = 30
let g:mundo_right = 1


" Autocomplete stuff

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

let g:completion_enable_snippet = 'vim-vsnip'
let g:completion_trigger_on_delete = 1

" 🐓 Coq completion settings
let g:coq_settings = { 'auto_start': 'shut-up', "keymap.recommended": v:false }

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- lspconfig object
local nvim_lsp = require'lspconfig'
local coq = require'coq'

local on_attach_js = function(client)
    require('nvim-lsp-ts-utils').setup({
        filter_out_diagnostics_by_code = { 80001 },
    })
    require('nvim-lsp-ts-utils').setup_client(client)
end

-- Enable rust_analyzer and ccls
nvim_lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities())
nvim_lsp.ccls.setup(coq.lsp_ensure_capabilities())
nvim_lsp.tsserver.setup(coq.lsp_ensure_capabilities({ on_attach=on_attach_js }))

-- Diagnostics config
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
        prefix = (vim.loop.os_uname()['release']:lower():match('microsoft') or vim.env.WSL_COMPAT) and "! " or "🗲 ",
    },
    signs = true,
    update_in_insert = false,
  }
)

EOF

" Setup sources
let g:completion_chain_complete_list = {
      \ 'default': [
      \    {'complete_items': ['buffer', 'tags', 'path']},
      \ ],
      \ 'c': [
      \    {'complete_items': ['lsp']},
      \ ],
      \ 'rust': [
      \    {'complete_items': ['lsp']},
      \ ],
      \ 'javascript': [
      \    {'complete_items': ['lsp']},
      \ ],
\ }
let g:completion_matching_strategy_list = ['exact', 'fuzzy']

" Coq Keybindings
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

" Code navigation shortcuts
au FileType rust nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
au FileType c nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
au FileType javascript nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <F2>    <cmd>lua vim.lsp.buf.rename()<CR>

" Visualize diagnostics
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '120'
let g:diagnostic_virtual_text_prefix = '! '
if !wsl_compat
      let g:diagnostic_virtual_text_prefix = '🗲 '
endif
" Don't show diagnostics while in insert mode
let g:diagnostic_insert_delay = 1

" Goto previous/next diagnostic warning/error
nnoremap <silent> dN <cmd>vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> dn <cmd>vim.lsp.diagnostic.goto_next()<cr>

" Enable type inlay hints
if !wsl_compat
      autocmd FileType rust autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
      \ lua require'lsp_extensions'.inlay_hints{ prefix = ' ⪢  ', highlight = "Comment" }
endif


" OSC52 copy sequence
if has('wsl')
    let g:clipboard = {
          \   'name': 'wslclipboard',
          \   'copy': {
          \      '+': '/usr/local/bin/win32yank.exe -i --crlf',
          \      '*': '/usr/local/bin/win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': '/usr/local/bin/win32yank.exe -o --lf',
          \      '*': '/usr/local/bin/win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 1,
          \ }
elseif wsl_compat
      function! s:ocs_yd(monika)
      " detect empty lines and do not put into register/clipboard
            let r = getline('.')
            if r =~ '^\s*$'
            if a:monika
                  return "\"_dd"
            else
                  return "\"ayy"
            endif
            else
                  return "\"ayy:OSCYankReg a\n" . (a:monika ? "\"_dd" : "")
            endif
      endfunction
      nnoremap <silent><expr> dd <SID>ocs_yd(1)
      nnoremap <silent><expr> yy <SID>ocs_yd(0)
      xnoremap y "ay:OSCYankReg +<CR>
      xnoremap d "ad:OSCYankReg +<CR>

else
      function! s:ocs_yd(monika)
      " detect empty lines and do not put into register/clipboard
            let r = getline('.')
            if r =~ '^\s*$'
            if a:monika
                  return "\"_dd"
            else
                  return "\"+yy"
            endif
            else
                  return "\"+yy:OSCYankReg +\n" . (a:monika ? "\"_dd" : "")
            endif
      endfunction
      nnoremap <silent><expr> dd <SID>ocs_yd(1)
      nnoremap <silent><expr> yy <SID>ocs_yd(0)
      xnoremap y "+y:OSCYankReg +<CR>
      xnoremap d "+d:OSCYankReg +<CR>
endif
nmap X dd


" vim-cutlass, but better and DIY
" delete a single char
nnoremap x "_d1<Right>
" over-paste in visual mode
xnoremap p "_dP
" change parts of line
nnoremap cc "aS
nnoremap C "aC
nnoremap c "ac


" Don't save changes to a directory
autocmd FileType netrw setl bufhidden=delete

" Unmap enter key in quickfix windows to allow default plugin behaviour
" (Fixes vim-ripgrep)
autocmd BufWinEnter quickfix map <buffer> <CR> <CR>

" sneak
let g:sneak#label = 1
let g:sneak#s_next = 0
let g:sneak#use_ic_scs = 1

" Gitgutter
autocmd BufWritePost * GitGutter
let g:gitgutter_sign_allow_clobber = 1
let g:gitgutter_preview_win_floating = 0

" Make it <TAB> completion
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
imap <silent><expr> <TAB>
      \ vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' :
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ "\<c-p>"
imap <silent><expr> <C-Space>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Space>" :
      \ "\<c-p>"
imap <silent><expr> <S-TAB>
      \ vsnip#available(1) ? '<Plug>(vsnip-jump-prev)' :
      \ pumvisible() ? "\<C-p>" :
      \ <SID>check_back_space() ? "\<Backspace>" :
      \ "\<c-p>"

inoremap <silent><expr> <Down>
      \ pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <silent><expr> <Up>
      \ pumvisible() ? "\<C-p>" : "\<Up>"

" Fix <CR> behaviour
" function! s:cr_function()
"     if pumvisible()
"         if empty(v:completed_item)
"             " Quickly select and unselect first element to work around weirdness
"             " with \n sometimes not doing what it's supposed to
"             return "\<C-n>\<C-p>\n"
"         else
"             return "\<Plug>(completion_confirm_completion)"
"         endif
"     else
"         return "\n"
"     endif
" endfunction
" inoremap <silent> <CR> <C-r>=<SID>cr_function()<CR>

" Snippet movement
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '\<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '\<S-Tab>'
snoremap K K
snoremap J J
snoremap gx gx

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
" set colorcolumn=120
" set textwidth=120
" execute "set colorcolumn=" . join(range(121,400), ',')

" Don't auto-insert comment header on newline, and don't auto-wrap long lines
au FileType * set fo-=r fo-=o fo+=l

" Auto-nohlsearch
set hlsearch
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" Required for autoread
au FocusGained,BufEnter * :silent! !

" Further Styling
highlight LspDiagnosticsVirtualTextError guifg=red
highlight LspDiagnosticsVirtualTextWarning guifg=yellow
highlight LspDiagnosticsSignError guifg=red
highlight LspDiagnosticsSignWarning guifg=yellow
highlight LspDiagnosticsUnderlineError gui=undercurl guisp=red term=undercurl cterm=undercurl
highlight LspDiagnosticsUnderlineWarning gui=undercurl guisp=yellow term=undercurl cterm=undercurl

" Scrollbar
augroup ScrollbarInit
  autocmd!
  autocmd WinScrolled,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
augroup end

" Nerdtree
map <F3> :NERDTreeMirror<CR>:NERDTreeToggle<CR>
map <F4> :wincmd w<CR>
let NERDTreeWinSize=40
let NERDTreeWinPos="left"
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Include local config
runtime local.vim

