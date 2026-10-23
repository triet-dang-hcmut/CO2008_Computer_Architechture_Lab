.data
array: .space 20 # Mang chua 5 element
prompt_input: .asciiz "Please input element "
colon: .asciiz ": "
prompt_index: .asciiz "Please enter index: "

.text
.globl main
main:
	li $t0, 0 #Bien dem
	la $t1, array
	
input: # Nhap 5 element
	li $v0, 4 # In "Please input element "
	la $a0, prompt_input
	syscall
	
	li $v0, 1 # In bien dem
	move $a0, $t0
	syscall
	
	li $v0, 4 # In dau ":"
	la $a0, colon
	syscall
	
	li $v0, 5 # Doc so (element)
	syscall
	
	# Luu element vao array
	sw $v0, 0($t1)
	
	addi $t0, $t0, 1 #Cap nhat bien dem
	addi $t1, $t1, 4 #Cap nhat dia chi array
	beq $t0, 5, index #Du 5 element -> chuyen qua index
	j input

index: # Nhap index
	li $v0, 4 # In "Please enter index:"
	la $a0, prompt_index
	syscall
	
	li $v0, 5 # Doc index
	syscall
	
	# Tra ve element tuong ung
	move $t0, $v0 # t0 tro thanh index
	la $t1, array # Ve lai dia chi co so cua array
	mul $t0, $t0, 4 # index*4
	add $t1, $t1, $t0 # &array[4*index]
	lw $t2, 0($t1)
	
	li $v0, 1 # In element
	move $a0, $t2
	syscall
	
	li $v0, 10 #Ket thuc
	syscall 
