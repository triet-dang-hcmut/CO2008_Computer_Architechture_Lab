.data
prompt_input: .asciiz "Please enter a positive integer less than 16: "
prompt_binary: .asciiz "Its binary form is: "

.text
.globl main
main: # Doc so
	li $t0, 2 
	
	li $v0, 4 
	la $a0, prompt_input
	syscall
	
	li $v0, 5 # Doc so
	syscall
	
	move $t1, $v0
	
	# Tim 4 bit
	div $t1, $t0
	mflo $t1 # thuong
	mfhi $t2 # $t2 = bit-0
	
	div $t1, $t0
	mflo $t1 # thuong
	mfhi $t3 # $t3 = bit-1
	
	div $t1, $t0
	mflo $t1 # thuong
	mfhi $t4 # $t4 = bit-2
	
	div $t1, $t0
	mflo $t1 # thuong
	mfhi $t5 # $t5 = bit-3
	
	# In so binary
	li $v0, 4
	la $a0, prompt_binary
	syscall
	
	li $v0, 1
	move $a0, $t5 #bit-3
	syscall

	li $v0, 1
	move $a0, $t4 #bit-2
	syscall	
	
	li $v0, 1
	move $a0, $t3 #bit-1
	syscall
	
	li $v0, 1
	move $a0, $t2 #bit-0
	syscall
	
	li $v0, 10 #Ket thuc
	syscall
	
	
	