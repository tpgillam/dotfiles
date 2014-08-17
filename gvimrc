"colorscheme macvim
"set background=dark
set background=light
colorscheme solarized

if has('mac')
  set guifont=Monaco:h10
elseif has('unix')
  set guifont=DejaVu\ Sans\ Mono\ 10
endif
set guioptions+=c " command prompt instead of gui
set guioptions-=e " Get rid of gui tabs
set guioptions-=m "Get rid of menu bar
set guioptions-=T " Get rid of toolbar
set guicursor+=a:blinkon0 " Disable cursor blinking
set novisualbell
set noerrorbells visualbell t_vb=
set cursorline
" set vb
