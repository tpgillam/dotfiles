set nocompatible
set backspace=indent,eol,start
syntax on
set foldmethod=syntax

" Don't store backup files. That's what git is for
set nobackup
set nowritebackup

" Don't pollute cwd with .swp files
set directory^=$HOME/.vim/tmp//

" Specify what we think of as keywords
set iskeyword=@,48-57,_,192-255

" Enable modeline processing
set modelines=1

" Tabs are ugly
set tabstop=4
set shiftwidth=4
set softtabstop=4
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
set nobackup
" if has("vms")
"   set nobackup		" do not keep a backup file, use versions instead
" else
"   set backup		" keep a backup file
" endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hlsearch " highlight searches

" Show line numbers - Hmmmm...
set number

" Automatic wrapping
set textwidth=120
set fo-=t

" Statusline stuff
set laststatus=2 
" Powerline/airline -- ideally need patched fonts from https://github.com/Lokaltog/powerline-fonts
" enable these for linux only here
if has("gui_running")
  if has("gui_gtk2")
    let g:airline_powerline_fonts = 1
  endif
endif

" Set airline theme
let g:airline_theme = 'bubblegum'

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

" Fix background colours over ssh with tmux
set t_ut=

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

" Set .md to markdown
au BufRead,BufNewFile *.md setfiletype markdown

" ChangeLog settings
let g:changelog_username = "Thomas Gillam  <tpgillam@googlemail.com>"

" Highlight column
" set colorcolumn=120
" let &colorcolumn=join(range(&l:textwidth + 1, &l:textwidth + 2),",")
highlight ColorColumn ctermbg=235 guibg=#2c2d27

function! s:SetColorColumn()
    if &textwidth == 0
        setlocal colorcolumn=81
    else
        setlocal colorcolumn=+1
    endif
endfunction

augroup colorcolumn
    autocmd!
    autocmd OptionSet textwidth call s:SetColorColumn()
    autocmd BufEnter * call s:SetColorColumn()
augroup end

" Experimental Vundle support!
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
" Bundle 'valloric/YouCompleteMe'
Bundle 'Keithbsmiley/tmux.vim'
Bundle 'Shougo/vimproc.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'bling/vim-airline'
Bundle 'evandrewry/vim-x10'
Bundle 'gmarik/Vundle.vim'
Bundle 'groenewege/vim-less'
Bundle 'kana/vim-operator-user'
Bundle 'keith/swift.vim'
Bundle 'lindemann09/jags.vim'
Bundle 'maverickg/stan.vim'
Bundle 'rhysd/vim-clang-format'
Bundle 'sjl/gundo.vim'
Bundle 'thinca/vim-localrc'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'vim-jp/vim-cpp'
Plugin 'flazz/vim-colorschemes'
Plugin 'JuliaEditorSupport/julia-vim'
filetype plugin indent on

" Default to dark background
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

" Adapt commentary to use "#" for Gnuplot comments
autocmd FileType gp set commentstring=#\ %s

" Adapt commentary to use "@c" for texinfo comments
autocmd FileType texinfo set commentstring=@c\ %s

" Adapt commentary to use "#" for gtkrc comments
autocmd FileType gtkrc set commentstring=#\ %s
"
" Adapt commentary to use "%" for bibtex comments
autocmd FileType bib set commentstring=%\ %s

" Adapt commentary to use "//" for STAN comments
autocmd FileType stan set commentstring=//\ %s

" Custom text width for Julia
autocmd FileType julia setlocal textwidth=92

" Color scheme option
colorscheme jellybeans

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

let b:clang_user_options = '-std=c++17'
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
if hostname == 'tigger'
  let g:clang_format#command = 'clang-format-mp-6.0'
elseif hostname == 'heffalump'
  let g:clang_format#command = 'clang-format-5.0'
endif
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 1
let g:clang_format#auto_format_on_insert_leave = 0
autocmd FileType cpp setlocal ts=4 sw=4 sts=4 et
autocmd FileType cpp set textwidth=120

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

" set YouCompleteMe global config file
let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'

" Disable auto triggering of YCM
let g:ycm_auto_trigger=0
