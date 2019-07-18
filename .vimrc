" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.

"------------------------------------------------------------
" Features {{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" System clipboard
set clipboard=unnamed

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on


"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
    
" Indentation settings for using hard tabs for indent. Display tabs as
" two characters wide.
"set shiftwidth=2
"set tabstop=2


"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" map enter to create newline in normal mode
map <CR> o<Esc>k
"------------------------------------------------------------
" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
  finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'bdelete'.a:bang.' '.btarget
  execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call s:Bclose('<bang>', '<args>')
nnoremap <silent> <Leader>bd :Bclose<CR>

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction


noremap -d :Bclose<CR>

" Search for python function definition
fun! DefSearch()
  let l:regex = 'def\s\s*' . expand('<cword>')
  echo regex
  if search(regex) == 0   " search failed
    silent 'grep -E "'  . regex . '" *.py'
  endif
endfun

"colorscheme fruity
let g:solarized_termcolors=256
execute pathogen#infect()
set background=dark
colorscheme solarized

filetype on
filetype plugin indent on
"set smartindent

au BufReadPost *.twig colorscheme koehler 
au BufReadPost *.css colorscheme slate 
au BufReadPost *.js colorscheme elflord 
au BufReadPost *.py colorscheme molokai
au BufReadPost *.html colorscheme monokai
au BufReadPost *.java colorscheme monokai
au BufReadPost *.php colorscheme monokai

" Python-specific mappings
au BufReadPost *.py noremap <C-d> :call DefSearch() <CR> 

" can use auto-pairs.vim if you want

"send the current line to the command window and execute it
noremap <C-i> "syy :exe @s <CR>
" send current line to be interpreted as python code
" doesn't work if there is no newline 
noremap <C-p> "syy :exe 'py ' . @s <CR>

" find the function definition from the current word (like # but better)
" how do this accress files?
noremap <C-d> :call search('def\s\s*' . expand('<cword>')) <CR>

" Search the current directory (shallow) for the word under the cursor
noremap <C-g> :exe ':grep ' . expand('<cword>') . ' *'  <CR>
"insert mode save
inoremap <c-s> <Esc>:update<CR>
noremap <C-s> :update<CR>

imap <tab> <Esc>
" Let window searching work from insert mode
inoremap <C-w> <Esc> <C-w>  

" now \s -> find/replace 
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/ 

"Trick (not mapping) <C-v> -> select column -> I -> {insert text} -> <Esc> <Esc>

command Py call PyAppendPath()

fun! PyAppendPath()
    exe 'py sys.path.append("' . getcwd() . '")'
    "get the filename without .py 
    exe 'py import ' . split(split(expand('%'), '/')[-1], '\.')[0] 
    echo "path added, file imported"
endfun

function! CountSpaces(type, ...)
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
  echomsg strlen(substitute(@@, '[^ ]', '', 'g'))
endfun

" see :h g@
" uses [/] marks along with visual mode to yank a custom selection of text.
fun! Echo(type, ...)
  "backticks=' (goto mark), have to avoid out-quoting string
  "clear the @q register for use in this function.
  "@q is the reserved phonim register.
  let @q=""
  " see :h g@ for more info and how to save and restore a register, which
  " would allow us to use 'q' only temporarily and then restore it 
  if a:0  " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . "`>y"
  elseif a:type == 'line'
    silent exe 'normal! `[V`]"qy'
  elseif a:type == 'block' " column ('block') selection. 
    silent exe 'normal! `[\<C-V>`]"qy'
  "v -> visual mode but stay in-line
  else " Stay in-line
    silent exe 'normal! `[v`]"qy'  
  endif 
  echo @q
  "call SpeakBlocking(@q)
endfun

"nmap <silent> <C-i> :set opfunc=Echo<CR>g@


"nmap <silent> <C-i> :set opfunc=NetBeansCommand<CR>g@

" Sends a string (replacing newlines with sapces) to netbeans via the :nbkey
" command
      
fun! SpeakBlocking(s)
  call Speak(a:s, 'speakBlocking')
endfun

fun! SpeakNonBlocking(s)
  call Speak(a:s, 'speak')
endfun

" speechType = speakBlocking or speak
fun! Speak(text, speechType)
  let l:sanitized = substitute(a:text, '\n', ' ', 'g')
  silent exe 'nbkey ' . speechType . ' ' .  sanitized
endfun

let s:allowedCommands =  ['speak', 'speakBlocking', 'getVolume']

fun! NetBeansCommand(cmd, ...)
  "note the allowedCommand list is incomplete.
  if (index(s:allowedCommands, a:cmd) < 0)
    echoerr "Not a vaild Command!"
    return "" " Not a valid command!
  else 
    if a:0 > 0 "a[0] holds number of optional arguments
      let l:arg = a:1 "grab the first (only optional) argument
"      silent exe 'echo ' . a:cmd . ' ' won't work because doesn't wrap them in quotes.
      echomsg  a:cmd . ' ' . l:arg
    else
      echomsg  a:cmd
    endif
  endif
endfun
  
" Autocommands time, with error checking.
" soon to come . . . 
"au CursorMoved * echo "foo" 
au BufRead,BufNewFile *.fasta,*.fa set filetype=fasta


let g:syntastic_python_checkers = ['mypy', 'flake8', 'prospector']

