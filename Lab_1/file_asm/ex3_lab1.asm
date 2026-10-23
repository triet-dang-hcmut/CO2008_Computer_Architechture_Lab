.data
prompt_a: .asciiz "Insert a: "
prompt_b: .asciiz "Insert b: "
prompt_c: .asciiz "Insert c: "
prompt_d: .asciiz "Insert d: "
prompt_F: .asciiz "F = "
prompt_remainder: .asciiz ", remainder "

.text
.globl main
main:	
	# Lay gia tri a,b,c,d
	# Lay gia tri a
	li $v0, 4
	la $a0, prompt_a
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0 # $t0 = a
	
	# Lay gia tri b
	li $v0, 4
	la $a0, prompt_b
	syscall
	
	li $v0, 5
	syscall
	
	move $t1, $v0 # $t1 = b
	
	# Lay gia tri c
	li $v0, 4
	la $a0, prompt_c
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0 # $t2 = c
	
	# Lay gia tri d
	li $v0, 4
	la $a0, prompt_d
	syscall
	
	li $v0, 5
	syscall
	
	move $t3, $v0 # $t3 = d
	
	# Tinh F va remainder
	# Tinh (a+10)x(b-d)x(c-2xa)
	addi $t4, $t0, 10 # $t4 = (a + 10)
	sub $t5, $t1, $t3 # $t5 = (b - d)
	add $t6, $t0, $t0
	sub $t7, $t2, $t6 # $t7 = (c - 2 x a)
	mul $s0, $t4, $t5
	mul $s0, $s0, $t7 # $s0 = (a+10)x(b-d)x(c-2xa)
	# Tinh (a+b+c)
	add $s1, $t0, $t1
	add $s1, $s1, $t2 # $s1 = (a+b+c)
	# Phep chia
	div $s0, $s1
	mflo $s2 # $s2 = F
	mfhi $s3 # $s3 = remainder
	
	li $v0, 4 
	la $a0, prompt_F
	syscall
	
	li $v0, 1 # In F
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, prompt_remainder
	syscall
	
	li $v0, 1 # In remainder
	move $a0, $s3
	syscall
	
	li $v0, 10 #Ket thuc
	syscall
	
	
