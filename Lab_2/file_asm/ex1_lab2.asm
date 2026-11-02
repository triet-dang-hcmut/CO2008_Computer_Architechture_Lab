.data
    array: .space 20
    prompt_input: .asciiz "Please input element "
    colon: .asciiz ": "
    prompt_oldarray: .asciiz "Old array: "
    prompt_newarray: .asciiz "New array: "
    square_bracket_begin: .asciiz "["
    square_bracket_end: .asciiz "]"
    comma: .asciiz ", "
    newline: .asciiz "\n"

.text
.globl main
main:
    li $t0, 0 # Bien dem
    la $t1, array # array chua 5 so nguyen

# 1. Input 
input: # Nhap 5 so nguyen
    # In prompt
    li $v0, 4
    la $a0, prompt_input
    syscall
    
    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, colon
    syscall

    # Nhap so
    li $v0, 5
    syscall

    # Cap nhat bien dem va array
    sw $v0, 0($t1)
    addi $t0, $t0, 1
    addi $t1, $t1, 4
    beq $t0, 5, print_oldarray
    j input

print_oldarray: # In array cu
    la $a1, prompt_oldarray
    jal printarray
    j check # Chuyen qua check so co chia het cho 4 ko

printarray:
    li $v0, 4
    move $a0, $a1
    syscall

    li $v0, 4
    la $a0, square_bracket_begin
    syscall

    la $t1, array # dia chi array[0]
    la $t0, array
    addi $t0, $t0, 16 # dia chi array[4]

loop_printarray: 
    li $v0, 1
    lw $a0, 0($t1) 
    syscall

    beq $t1, $t0, end_printarray

    li $v0, 4
    la $a0, comma
    syscall

    addi $t1, $t1, 4
    j loop_printarray
    

end_printarray:
    li $v0, 4
    la $a0, square_bracket_end
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    jr $ra # Ve lai print_(old/new)array

# 2. Check
check: # Kiem tra chia het cho 4
    la $t1, array # dia chi array[0]
    la $t0, array 
    addi $t0, $t0, 16 # dia chi array[4]
    li $s0, 4

div_4:
    lw $t2, 0($t1)
    div $t2, $s0
    mflo $t3 # Thuong  
    mfhi $t4 # So du
    bne $t4, 0, change # Chuyen qua change so ko chia het cho 4
    beq $t1, $t0, print_newarray # Chuyen qua in array moi
    addi $t1, $t1, 4
    j div_4

change: # Chinh so ko chia het cho 4
    # *Xet so duong (so > 0)
    # - Neu du 1 -> thuong * 4 (round down)
    # - Neu du 2 -> thuong * 4 (round down)
    # - Neu du 3 -> (thuong + 1) * 4 
    #  *Xet so am (so < 0) 
    # - Neu du -1 -> thuong * 4 (round down)
    # - Neu du -2 -> (thuong - 1) * 4
    # - Neu du -3 -> (thuong - 1) * 4
    beq $t4, 1, save
    beq $t4, 2, save
    beq $t4, 3, round_up_positive
    beq $t4, -1, save
    addi $t3, $t3, -1 # Lam tron xuong
    j save

round_up_positive: # Lam tron len
    addi $t3, $t3, 1
    j save

save: # Luu lai so moi
    mul $t3, $t3, 4
    sw $t3, 0($t1)
    beq $t1, $t0, print_newarray # Chuyen qua in array moi
    addi $t1, $t1, 4
    j div_4

print_newarray: # In array moi
    la $a1, prompt_newarray
    jal printarray
    j end # Ket thuc chuong trinh

end:
    li $v0, 10
    syscall