" Only do this when not done yet for this buffer
if exists("b:did_scheme_eval_ftplugin")
  finish
endif
let b:did_scheme_eval_ftplugin = 1


" Add mappings, unless the user didn't want this.
if !exists("no_plugin_maps") && !exists("no_mail_maps")
  " Quote text by inserting "> "
  if !hasmapto('<Plug>Scheme')
    " Execute current motion or visual selection in mit-scheme
    vmap <buffer> <LocalLeader>r <Plug>Scheme
    nmap <buffer> <LocalLeader>r <Plug>Scheme
  endif
endif
