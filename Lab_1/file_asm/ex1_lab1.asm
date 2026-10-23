.data:
hello: .asciiz "Hello, "
name: .space 50 # Ten (toi da 50 ki tu)
exclamation_mark: .asciiz "!"

.text
.globl main
main:
	# Nhap chuoi
	# syscall 8 se bi van de tu dong them \n sau name VD nhu "John\n"
	li $v0, 8 # Doc ten va luu vao name
	la $a0, name 
	li $a1, 50 # toi da 50 ki tu
	syscall
	
	# Xoa \n trong name
	la $s0, name 
	li $t1, 10 # ma ascii cua "\n"
loop:
	lbu $t0, 0($s0)
	beq $t0, $0, print # Neu ki tu la "\0" -> chuyen qua print ($0 = \0)
	beq $t0, $t1, change # Neu ki tu la "\n" -> chuyen qua change
	addi $s0, $s0, 1
	j loop

change: # Doi \n thanh \0
	sb $zero, 0($s0)

print: # In name
	li $v0, 4 # In chu "Hello, "
    	la $a0, hello
    	syscall
    	
    	la $a0, name # In name
    	syscall
    	
    	la $a0, exclamation_mark #In dau "!"
    	syscall

    	li $v0, 10 #Ket thuc
    	syscall
	
	

