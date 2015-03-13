" Vim highlighting for FASTA file headers
" Language: FASTA sequence 
 
syn region fastaID start=">" end="\n"
 
hi def link fastaID Type