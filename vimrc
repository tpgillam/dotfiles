set nocompatible
set backspace=indent,eol,start
syntax on
set foldmethod=syntax

" Specify what we think of as keywords
set iskeyword=@,48-57,_,192-255

" Enable modeline processing
set modelines=1

" Tabs are ugly
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set cindent
set autoindent
" set mouse=a
" Fix lines starting with # not indenting properly
set cinkeys-=0#
set t_kb= 			" Fix backspace key on ssh connections
" Allow backspace to delete characters
set backspace=2
set spelllang=en_gb
filetype on
filetype indent on
filetype plugin on
" Load c-completion tags see
" :help ft-c-omni for how to generate
set tags +=~/.vim/systags
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hlsearch " highlight searches

" Qt highlighting stuff - random options the guy likes
"color pablo " Pablo colour scheme - this might be a bad idea
set number " Show line numbers - Hmmmm...

" Automatic wrapping at 80 characters. Horrible for coding, nice for latex...
set textwidth=80
set fo-=t

" Statusline stuff
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2 

" GLSL highlighting
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
"
" Protocol buffer highlighting
augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end
 
" OpenCL highlighting
augroup filetype
  au! BufRead,BufNewFile *.cl,*.opencl setfiletype opencl
augroup end

" Set .icc (Athena standard for template implementation) to cpp
au BufRead,BufNewFile *.icc setfiletype cpp

" Set .kv to kivy
au BufRead,BufNewFile *.kv setfiletype kivy

" ChangeLog settings
let g:changelog_username = "Thomas Gillam  <gillam@hep.phy.cam.ac.uk>"

" Highlight 80th column
" set colorcolumn=80

" Experimental Vundle support!
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
Bundle 'gmarik/Vundle.vim'
Bundle 'evandrewry/vim-x10'
Bundle 'sjl/gundo.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-dispatch'
Bundle 'Rip-Rip/clang_complete'
" Bundle 'davidhalter/jedi-vim'
Bundle 'ervandew/supertab'
Bundle 'rhysd/vim-clang-format'
Bundle 'groenewege/vim-less'
Bundle 'Keithbsmiley/tmux.vim'
filetype plugin indent on

" Default to light background
set background=dark

" Gundo toggling
nnoremap <F5> :GundoToggle<CR>

" Ensure python tabbing behaves how I want it to
autocmd FileType python setlocal ts=4 sw=4 sts=4 et
autocmd BufReadPost fugitive://* set bufhidden=delete

" Adapt commentary to use "//" for C++ comments
autocmd FileType cpp set commentstring=//\ %s

" Adapt commentary to use "#" for Cmake comments
autocmd FileType cmake set commentstring=#\ %s

" Adapt commentary to use "{#" for htmldjango comments
autocmd FileType htmldjango set commentstring={#\ %s\ #}

" Adapt commentary to use "#" for tmux comments
autocmd FileType tmux set commentstring=#\ %s

" Setup for clang_complete
" Clang library file has to have correct name (on Ubuntu needed to create
" symlink libclang.so -> libclang.so.1)
let hostname = substitute(system('hostname'), '\n', '', '')
if has('mac')
  let g:clang_library_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
elseif hostname == "heffalump"
  let g:clang_library_path = "/usr/lib/x86_64-linux-gnu"
elseif has('unix')
  let g:clang_library_path = "/usera/gillam/utils/clangStuff/build/Release+Asserts/lib"
endif

let b:clang_user_options = '-std=c++11'
let g:clang_use_library = 1
let g:clang_close_preview = 1
" let g:clang_complete_copen = 1
" let g:clang_periodic_quickfix = 1
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<c-x><c-u>'
let g:clang_complete_auto = 1

" " Trying to get function parameter stuff working
" set conceallevel=2
" set concealcursor=vin
" let g:clang_snippets=1
" let g:clang_conceal_snippets=1
" " The single one that works with clang_complete
" let g:clang_snippets_engine='clang_complete'

" Set clang-format binary
if has('mac')
  let g:clang_format#command = 'clang-format-mp-3.6'
elseif hostname == 'heffalump'
  let g:clang_format#command = 'clang-format-3.5'
endif

" Complete options (disable preview scratch window, longest removed to aways
" show menu)
set completeopt=menu,menuone

" Nuke preview window when not wanted
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Jedi-Vim customisation
let g:jedi#completions_command = "<C-X><C-U>"
let g:jedi#popup_on_dot = 0


" For LaTeX, disable conceal annoyances
let g:tex_conceal=""

" More tags for html indenting
let g:html_indent_inctags = "html,body,head,tbody"

" Highlight colours for dark background
hi Pmenu      ctermfg=Cyan    ctermbg=Blue cterm=None guifg=Cyan  guibg=DarkBlue
hi PmenuSel   ctermfg=White   ctermbg=Blue cterm=Bold guifg=White guibg=DarkBlue gui=Bold
hi PmenuSbar                  ctermbg=Cyan            guibg=Cyan
hi PmenuThumb ctermfg=White                           guifg=White
