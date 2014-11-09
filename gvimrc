"colorscheme macvim
set background=dark
" set background=light
colorscheme gruvbox

if has('mac')
  set guifont=Monaco:h10
elseif has('unix')
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
endif
set guioptions+=c " command prompt instead of gui
set guioptions-=e " Get rid of gui tabs
set guioptions-=m " Get rid of menu bar
set guioptions-=T " Get rid of toolbar
set guioptions-=r " Get rid of right scrollbar
set guioptions-=l " Get rid of left scrollbar
set guioptions-=R " Get rid of right scrollbar with vertical split
set guioptions-=L " Get rid of left scrollbar with vertical split
set guicursor+=a:blinkon0 " Disable cursor blinking
set novisualbell
set noerrorbells visualbell t_vb=
set cursorline
" set vb
