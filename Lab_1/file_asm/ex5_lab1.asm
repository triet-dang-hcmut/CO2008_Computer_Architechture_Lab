.data
array: .word 1, 2, 5, 8, 12, 44, 3, 9, 0, 10 #mang cho truoc
comma: .asciiz ", "

.text
.globl main
main:
	li $t0, 9 #index chi so cuoi
	la $t1, array
	addi $t1, $t1, 36
	
print:
	li $v0, 1
	lw $t2, 0($t1)
	move $a0, $t2
	syscall

	beq $t0, 0, end # het so de in -> end
	
	li $v0, 4
	la $a0, comma
	syscall
	
	addi $t0, $t0, -1
	addi $t1, $t1, -4 
	j print
	
end:
	li $v0, 10
	syscall