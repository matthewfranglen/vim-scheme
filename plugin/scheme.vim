" scheme.vim - Shell commands write to a vim buffer
" Maintainer: Matthew Franglen
" Version:    0.0.1

if exists('g:loaded_scheme') || &compatible
  finish
else
  let g:loaded_scheme = 1
endif

" Execute current motion or visual selection in mit-scheme

nmap <silent> <leader>r :set opfunc=ExecuteMotionInScheme<CR>g@
vmap <silent> <leader>r :<C-U>call ExecuteMotionInScheme(visualmode(), 1)<CR>

function! ExecuteMotionInScheme(type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use '< and '> marks.
      silent exe "normal! `<" . a:type . "`>y"
    elseif a:type == 'line'
      silent exe "normal! '[V']y"
    elseif a:type == 'block'
      silent exe "normal! `[\<C-V>`]y"
    else
      silent exe "normal! `[v`]y"
    endif

    call s:ExecuteInScheme(@@)

    let &selection = sel_save
    let @@ = reg_save
endfunction

function! s:ExecuteInScheme(commands)
    echo 'Evaulating scheme ...'

    call s:LoadBuffer()
    call system('mit-scheme', a:commands)
    call s:ResizeBuffer()

    echo 'Scheme evaluation completed ...'
endfunction

function! s:LoadBuffer()
    let winnr = bufwinnr('^SCHEME-BUFFER$')
    silent! execute  winnr < 0 ? 'botright new SCHEME-BUFFER' : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
endfunction

" This resizes to the length of the output, but no more than one third of the screen.
function! s:ResizeBuffer()
    let one_third = &lines / 3
    let command_size = line('$')
    let window_size = command_size < one_third ? command_size : one_third
    silent! execute 'resize ' . window_size

    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
endfunction
