" scheme.vim - Shell commands write to a vim buffer
" Maintainer: Matthew Franglen
" Version:    0.3

if exists('g:loaded_scheme') || &compatible
  finish
else
  let g:loaded_scheme = 1
endif

if !exists('g:scheme_evaluator')
    let g:scheme_evaluator = 'mit-scheme --quiet'
endif

" Ex mode range command
command! -range Scheme <line1>,<line2>call s:ExecuteRangeInScheme()

" Execute current motion or visual selection in mit-scheme
noremap <silent> <Plug>Scheme :set opfunc=ExecuteMotionInScheme<CR>g@
vnoremap <silent> <Plug>Scheme :<C-U>call ExecuteMotionInScheme(visualmode(), 1)<CR>

" Invoked from ex mode, this accepts a range and interprets it
function! s:ExecuteRangeInScheme()
    call s:ExecuteInScheme(getline(a:firstline, a:lastline))
endfunction

" Invoked from normal and visual mode, this accepts a motion and interprets it
" help :map-operatior
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

" Executes the lisp commands and shows the results in a new buffer
" Commands can be a string or a list
function! s:ExecuteInScheme(commands)
    echo 'Evaulating scheme ...'

    call s:LoadBuffer()

    " Clear the buffer, loading it put us in it.
    normal! ggdG

    " Execute the commands and handle newlines in the output
    let l:raw_output = system(g:scheme_evaluator, a:commands)
    let l:output = split(l:raw_output, '\n')
    call setline(line('.'), l:output)

    call s:ResizeBuffer()

    echo 'Scheme evaluation completed ...'
endfunction

" Creates or moves to the scheme output buffer
function! s:LoadBuffer()
    let winnr = bufwinnr('^SCHEME-BUFFER$')
    silent! execute  winnr < 0 ? 'botright new SCHEME-BUFFER' : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
endfunction

" This resizes to the vertical height of the scheme output buffer.
" It will never be more than one third of the screen.
function! s:ResizeBuffer()
    let one_third = &lines / 3
    let command_size = line('$')
    let window_size = command_size < one_third ? command_size : one_third
    silent! execute 'resize ' . window_size

    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
endfunction
