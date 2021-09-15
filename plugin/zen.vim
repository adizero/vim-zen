" ============================================================================
" File:        zen.vim
" Description: Zen mode for Vim
" Author:      Adrian Kocis <adrian.kocis@nokia.com>
" Licence:     Vim licence
" Website:     
" Version:     1.0
" Note:        Hides everything including tmux status bar, statusline, tabline
"              to have one a single fullscreen buffer view
"
" ============================================================================
"
if &compatible || exists('g:loaded_zen')
    finish
endif
let g:loaded_zen = 1

let g:zen_mode = 0

command! Zen call zen#toggle_zen()
call g:CommandModeAbbreviation('zen', 'Zen', 0)
