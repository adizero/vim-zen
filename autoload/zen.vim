function! s:is_tmux_running() abort
    return $TMUX !=# ''
endfunction

function! s:store_current_state() abort
    let g:zen_old_airline_autocmd_exists = exists('#airline')
    if s:is_tmux_running()
        let g:zen_old_tmux_status = trim(system('tmux show status'))
    endif
    let g:zen_old_laststatus=&laststatus
    let g:zen_old_showtabline=&showtabline
    if has('cmdline_info')
        let g:zen_old_ruler=&ruler
        let g:zen_old_showcmd=&showcmd
    endif
    let g:zen_old_showmode=&showmode
    let g:zen_old_cmdheight=&cmdheight
    let g:zen_old_signcolumn=&l:signcolumn
    let g:zen_old_number=&l:number
    let g:zen_old_relativenumber=&l:relativenumber
    if has('statusline')
        let g:zen_old_statusline = &l:statusline
    endif
    let g:zen_old_airline_autocmd_exists = exists('#airline')
endfunction

function! s:set_zen_state() abort
    if g:zen_old_airline_autocmd_exists
        AirlineToggle
    endif

    if s:is_tmux_running()
        if g:zen_old_tmux_status ==# '' || g:zen_old_tmux_status ==# 'status on'
            call system('tmux set status off')
            augroup zen
                autocmd!
                autocmd VimLeavePre * call s:restore_tmux()
            augroup END
        endif
    endif
    let &g:laststatus = 0
    let &g:showtabline = 0
    if has('cmdline_info')
        let &g:ruler = v:false
        let &g:showcmd = v:false
    endif
    let &g:showmode = v:false
    try
        let &g:cmdheight = 0
    catch
        " in current Vim/Neovim cmdheight 0 is not (yet) supported
        " echo 'cmdheight 0 is not supported'
        let &g:cmdheight = 1
    endtry
	" Todo(akocis): these need to be set to all tabs/windows/buffers
    let &l:signcolumn = 'no'
    let &l:number = v:false
    let &l:relativenumber = v:false
    if has('statusline')
        let &l:statusline = '%#Normal# '
    endif
endfunction

function! s:restore_tmux() abort
    if s:is_tmux_running()
        if g:zen_old_tmux_status ==# ''
            call system('tmux set -u status')
        elseif g:zen_old_tmux_status ==# 'status on'
            call system('tmux set status on')
        endif
    endif
endfunction

function! s:restore_old_state() abort
    call s:restore_tmux()
    let &g:laststatus = g:zen_old_laststatus
    let &g:showtabline = g:zen_old_showtabline
    if has('cmdline_info')
        let &g:ruler = g:zen_old_ruler
        let &g:showcmd = g:zen_old_showcmd
    endif
    let &g:showmode = g:zen_old_showmode
    let &g:cmdheight = g:zen_old_cmdheight
	" Todo(akocis): these need to be reset in all tabs/windows/buffers
    let &l:signcolumn = g:zen_old_signcolumn
    let &l:number = g:zen_old_number
    let &l:relativenumber = g:zen_old_relativenumber
    if has('statusline')
        let &l:statusline = g:zen_old_statusline
    endif

    if g:zen_old_airline_autocmd_exists
        AirlineToggle
    endif
endfunction

function! s:enter_zen() abort
    if g:zen_mode
        return
    endif
    call s:store_current_state()
    call s:set_zen_state()
    let g:zen_mode = 1
endfunction

function! s:leave_zen() abort
    if !g:zen_mode
        return
    endif
    call s:restore_old_state()
    let g:zen_mode = 0
endfunction

function! zen#toggle_zen() abort
    if !g:zen_mode
        call s:enter_zen()
    else
        call s:leave_zen()
    endif
endfunction
