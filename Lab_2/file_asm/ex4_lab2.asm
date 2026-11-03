.data
    prompt_novalue: .asciiz "A factorial for your number can not be found"

.text
.globl main
main:
    li $v0, 5
    syscall

    blt $v0, 0, error
    move $s0, $v0
    jal factorial
    j print

# factorial (n) = n * factorial(n-1), fact(n) = 1 neu n <= 1
factorial:
    addi $sp, $sp, -8
    sw $ra, 4($sp) # dia chi tro ve
    sw $s0, 0($sp) # n 
    bgt $s0, 1, factorial_recursion # n > 1 -> de quy
    li $s1, 1  # n <= 1 -> fact = 1
    j factorial_return

factorial_recursion:
    addi $s0, $s0, -1 # n-1
    jal factorial # $s1 = (n-1)!
    lw $s0, 0($sp) # lay lai n cua lan goi nay
    mul $s1, $s1, $s0 # n * (n-1)!

factorial_return:
    lw $ra, 4($sp) # khoi phuc dia chi tro ve
    addi $sp, $sp, 8
    jr $ra

print:
    li $v0, 1
    move $a0, $s1
    syscall
    j end

error:
    li $v0, 4
    la $a0, prompt_novalue
    syscall

end:
    li $v0, 10
    syscall