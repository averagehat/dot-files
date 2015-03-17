
" Vim highlighting for FASTQ file headers
" Language: FASTQ sequence 
" \+ need backslash before + 
"
syn region fastqSeqID start="^@" end="\n" nextgroup=seq
syn match seq "^[ACGT]\+\n" nextgroup=description contained
syn region description start="^+" end="\n" nextgroup=quality contained

syn match q1 "[*,-./012]" contained 
syn match q0 "[!"#$%&'()]" contained 
syn match q3 "[<=>?@ABCD]" contained 
syn match q2 "[3456789:;]" contained 
syn match q5 "[NOPQRSTUV]" contained 
syn match q4 "[EFGHIJKLM]" contained 
syn match q7 "[`abcdefgh]" contained 
syn match q6 "[WXYZ[\]^_]" contained 
syn match q9 "[rstuvwxyz]" contained 
syn match q8 "[ijklmnopq]" contained 

syn match quality "^[\!\"\#\$\%\&\'\(\)\*\+,\-\./0123456789:;<=>\?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\[\]\^_\`abcdefghijklmnopqrstuvwxyz\{\|\}\~\\]\+\n" contains=q1, q0, q3, q2, q5, q4, q7, q6, q9, q8 contained oneline

hi def link fastqSeqID Comment
hi def link description Constant
hi def link seq Type
hi def link quality Function

hi def link q1  qc0
hi def link q0  qc1
hi def link q3  qc2
hi def link q2  qc3
hi def link q5  qc4
hi def link q4  qc5
hi def link q7  qc6
hi def link q6  qc7
hi def link q9  qc8
hi def link q8  qc9
" Define gradients for the quality
hi qc0  ctermfg=255  ctermbg=30
hi qc1  ctermfg=255  ctermbg=50
hi qc2  ctermfg=255  ctermbg=70
hi qc3  ctermfg=255  ctermbg=90
hi qc4  ctermfg=255  ctermbg=110
hi qc5  ctermfg=255  ctermbg=130
hi qc6  ctermfg=255  ctermbg=150
hi qc7  ctermfg=255  ctermbg=170
hi qc8  ctermfg=255  ctermbg=190
hi qc9  ctermfg=255  ctermbg=210




