
.data
Filename: .asciiz "inputs/dup1p.txt"
OutFile: .asciiz "out.txt"
Buffer:
    .word 0	# num rows
    .word 0	# num columns
    # matrix
    .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0


.text
main:
 la $a0, Filename
 la $a1, Buffer
 jal initialize
 la $a0, Buffer
 jal duplicate
 
 

 
 # write additional test code as you deem fit.

 li $v0, 10
 syscall

.include "hw3.asm"
