.data
    array: .space 40 # Array chua 10 element integer
    index: .space 40
    prompt_input: .asciiz "Please insert an element: "
    prompt_value: .asciiz "Second largest value is "
    prompt_index: .asciiz ", found in index "
    prompt_novalue: .asciiz "There is no second largest value!"
    prompt_array_begin: .asciiz "Array: ["
    prompt_array_end: .asciiz "]\n"
    comma: .asciiz ", "

.text
.globl main
main:
    la $t0, array
    li $t1, 1

input: # Nhap so vao array
    li $v0, 4
    la $a0, prompt_input
    syscall

    li $v0, 5
    syscall

    sw $v0, 0($t0)
    beq $t1, 10, printarray
    addi $t0, $t0, 4
    addi $t1, $t1, 1
    j input

printarray:
    la $t0, array
    addi $t1, $t0, 36

    li $v0, 4
    la $a0, prompt_array_begin
    syscall

loop_printarray:
    li $v0, 1
    lw $a0, 0($t0)
    syscall

    beq $t0, $t1, end_printarray
    
    li $v0, 4
    la $a0, comma
    syscall

    addi $t0, $t0, 4
    j loop_printarray

end_printarray:
    li $v0, 4
    la $a0, prompt_array_end
    syscall

max:
    la $t0, array
    lw $s0, 0($t0) # $s0 = max = array[0] 
    addi $t1, $t0, 36 # array[9]
    addi $t2, $t0, 4 # array[1]

loop_max:
    lw $t3, 0($t2)
    blt $s0, $t3, change_max

update_loop_max:
    beq $t2, $t1, second_max
    addi $t2, $t2, 4
    j loop_max

change_max:
    move $s0, $t3
    j update_loop_max

second_max:
    li $s2, 0 # Count index cua second largest
    la $s3, index # index[0]
    la $t0, array # array[0]
    li $t1, 0 # Index cua array[i]
    li $t2, 0 # Bool check da co second_max chua

loop_second_max:
    lw $t3, 0($t0)
    beq $t3, $s0, update_loop_second_max # array[i] == max -> bo qua
    beq $t2, $zero, new_second # Chua co second -> Them second moi 
    blt $t3, $s1, update_loop_second_max # second moi < second cu -> bo qua
    beq $t3, $s1, update_index # second moi = second cu -> cong index
    blt $s1, $t3, new_second # second moi > second cu -> update second moi

new_second:
    move $s1, $t3
    li $t2, 1 # found = true
    li $s2, 0 # Reset count = 0 trong TH update second moi
    la $s3, index # Ve lai index[0]

update_index:
    sw $t1, 0($s3)
    addi $s2, $s2, 1
    addi $s3, $s3, 4

update_loop_second_max:
    beq $t1, 9, check
    addi $t1, $t1, 1
    addi $t0, $t0, 4
    j loop_second_max

check:
    beq $t2, 0, error

printvalue:
    li $v0, 4
    la $a0, prompt_value
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, prompt_index
    syscall

    la $t0, index
    li $t1, 1

loop_printindex:
    li $v0, 1
    lw $a0, 0($t0)
    syscall

    beq $t1, $s2, end

    li $v0, 4
    la $a0, comma
    syscall

    addi $t1, $t1, 1
    addi $t0, $t0, 4
    j loop_printindex

error:
    li $v0, 4
    la $a0, prompt_novalue
    syscall

end:
    li $v0, 10
    syscall





