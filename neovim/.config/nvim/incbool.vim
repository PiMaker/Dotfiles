" Based on: https://github.com/can3p/incbool.vim

if exists("loaded_incbool")
  finish
endif
let loaded_incbool = 1

let g:incbool_table = { 'false': 'true', 'on': 'off', 'yes': 'no' }

" include reverse mappings
for k in keys(g:incbool_table)
  let g:incbool_table[g:incbool_table[k]] = k
endfor

function! SwapBooleans(char)
  let line = getline('.')
  let l = line('.')
  let c = col('.') - 1

  let word_start = match(line[:c], '\w\+$')
  let word_end = match(line, '\W', word_start)
  if word_end == -1
    let word = line[word_start :]
  else
    let word = line[word_start : word_end-1]
  endif

  let convert = ''
  let lword = tolower(word)
  try
    " if key doesn't exist, this fails and we do the catch path
    let convert = g:incbool_table[lword]

    if word ==# toupper(word)
      let convert = toupper(convert)
    elseif word ==# toupper(word[0]) . word[1:]
      let convert = toupper(convert[0]) . convert[1:]
    endif

    if word_end == -1
      let newline = (word_start>0 ? line[:word_start-1] : '') . convert
    else
      let newline = (word_start>0 ? line[:word_start-1] : '') . convert . line[word_end :]
    endif

    call setline(l, newline)
  catch
    execute 'normal! ' . v:count1 . a:char
  endtry
endfunction

nnoremap <silent> <C-a> :<C-u>call SwapBooleans("\<C-a>")<CR>
nnoremap <silent> <C-x> :<C-u>call SwapBooleans("\<C-x>")<CR>

