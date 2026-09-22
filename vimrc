
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupcopy=yes
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif


" Activate Pathogen
call pathogen#infect()
call pathogen#helptags()

" Switch syntax highlighting on, when the terminal has colors
" Also switch off highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set nohlsearch
endif

set spl=oxford spell

" Setup hard tabs (4 spaces)  as default indent
set tabstop=4
set shiftwidth=4
set softtabstop=0
set noexpandtab

set nofoldenable


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType python setlocal ts=4 sts=4 sw=4 tw=120 expandtab nofoldenable
  autocmd FileType mmd setlocal ts=4 sts=4 sw=4 tw=120 expandtab nofoldenable

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=120

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

set number

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has("statusline")
 set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
 set laststatus=2
endif

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
    let l:modeline = printf(" vim: set tw=%d ts=%d sw=%d sts=%d %set :",
                \ &textwidth, &tabstop, &shiftwidth, &softtabstop, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" My own mappings
" Toggle showing all characters.
set lcs=tab:␉-⇥,eol:␤,trail:␠,nbsp:⍽,extends:⥅,precedes:⥆,conceal:⬚
nmap <Leader>l :set list!<CR>
nmap <Leader>r :set relativenumber!<CR>


" Customizations for LaTeX-Suite
let g:Tex_ViewRule_pdf = 'Preview'



" Customization for vim-markdown
let g:vim_markdown_folding_disabled=1


" Customization for (builtin) Python syntax file
let python_space_error_highlight = 1


syntax enable
if has('gui_running')
	set background=light
else
	set background=dark
endif
colorscheme solarized

let g:DirDiffDynamicDiffText = 1

" pymode settings:
let g:pymode_python = 'python3'
"let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'pep257', 'pylint']


" From https://www.reddit.com/r/vim/comments/cn20tv/tip_histogrambased_diffs_using_modern_vim/
if has('nvim-0.3.2') || has("patch-8.1.0360")
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif

" Activate the matchit plugin (builtin)
packadd! matchit

" From <http://vimcasts.org/episodes/tabs-and-spaces/>
" Set tabstop, softtabstop and shiftwidth to the same value
" invoked by `:Stab` (in Normal mode)
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction



" For `vim-scala` plugin. Sets documentation comments to use Scala
" recommendations instead of Java.
let g:scala_scaladoc_indent = 1



" Let vim-javascript highlight JSDocs as well.
let g:javascript_plugin_jsdoc = 1



" ALE configuration stuff
let g:ale_linter_aliases = {
\	'mmd': 'markdown'
\}

" Set [standard](https://standardjs.com/) as the linter and fixer for JavaScript
" instead of eslint.
let g:ale_linters = {
\	'javascript': ['standard'], 
\	'python': ['pylint'], 
\	'markdown': ['markdownlint', 'redpen', 'textlint', 'vale'],
\	'mmd': ['markdownlint', 'redpen', 'textlint', 'vale']
\}
let g:ale_fixers = {
\	'javascript': ['standard'],
\	'python': ['isort', 'black'], 
\}
"let g:ale_lint_on_save = 1
"let g:ale_fix_on_save = 1

let g:ale_python_pylint_options = "--init-hook='import sys; sys.path.append(\".\")'"

" End of ALE configuration

" Limits the concealment madness, especially in LaTeX
" Turns off concealment in Insert mode and Visual selection mode.
let g:indentLine_concealcursor="c"
set concealcursor=c


" Tips from https://youtu.be/XA2WjJbmmoM
"
" Get a selection menu when matching multiple files
set wildmenu

"Create a `tags` file
command! MakeTags !ctags -R .


"Disable cursor keys to learn h,j,k,l better
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>





