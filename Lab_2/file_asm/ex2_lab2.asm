.data
    prompt_a: .asciiz "a = "
    prompt_b: .asciiz "b = "
    prompt_gcd: .asciiz "GCD = "
    prompt_lcm: .asciiz "LCM = "
    comma: .asciiz ", "
    prompt_negative_number: .asciiz "Not Positive Value! Please try again..."

.text
.globl main
main: # Doc gia tri a va b
    li $v0, 4
    la $a0, prompt_a
    syscall

    li $v0, 5
    syscall

    ble $v0, $zero, error # a <= 0 -> Loi
    move $s0, $v0 # $s0 = a

    li $v0, 4
    la $a0, prompt_b
    syscall

    li $v0, 5
    syscall

    ble $v0, $zero, error # b <= 0 -> Loi
    move $s1, $v0 # $s1 = b

# Su dung thuat toan Euclid GCD(a,b) = GCD(b,a%b)
gcd:
    move $t0, $s0 # $t0 = a
    move $t1, $s1 # $t1 = b
    j loop_gcd

loop_gcd:
    div $t0, $t1 # a / b
    mfhi $t2 # a % b
    move $t0, $t1 # $t0 = b
    move $t1, $t2 # $t1 = a % b
    beq $t1, $zero, set_gcd # b == 0 -> gcd = a
    j loop_gcd

set_gcd:
    move $s2, $t0 # GCD(a,b)

# Cong thuc LCM(a,b) = (a * b) / GCD(a,b)
lcm:
    move $t0, $s0 # $t0 = a
    move $t1, $s1 # $t1 = b
    div $t0, $s2
    mflo $t0 # a / GCD(a,b)
    mul $s3, $t0, $t1 # (a / GCD(a,b)) * b
    j print

print: # In GCD va LCM
    li $v0, 4
    la $a0, prompt_gcd
    syscall

    li $v0, 1
    move $a0, $s2
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 4
    la $a0, prompt_lcm
    syscall

    li $v0, 1
    move $a0, $s3
    syscall
    j end

error:
    li $v0, 4
    la $a0, prompt_negative_number
    syscall
    j end

end:
    li $v0, 10
    syscall