# Ternia Wilson
# 02894922 % 11 = 8
# 8 + 26 = Base 34

.data  # data section
    myMessage: .asciiz "Please enter a string of up to 100 characters: \n"
    myArray: .space 101 # this creates space for the users input
    invalidMessage: .asciiz "Invalid input\n"
    array: .word 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 # space for an array of 20 elements

.text
main:

    li $v0, 4 # prints out string
    la $a0, myMessage
    syscall

    li $v0, 8 # accepts user input
    la $a0, myArray
    li $a1, 100 # specifies the length that the user can input
    syscall

    lw $t0, myArray # load instruction that takes the word in $t0
    sub $sp, $sp, 12 # moves pointer for stack
    sw $t0, 4($sp) # adds the input string to the stack
    la $a0, array # load instruction into the array
    la $a1, myArray

    jal validString # determines if the string is valid by jumping to subprogram
    add $t1, $v0, $zero
    li $v0, 1
    move $a0, $t1
    syscall # prints the equivalent result of the decimal base number 34
    li $v0, 10
    syscall

validString:
    sw $ra, 0($sp)
    li $t1, 20
    li $t2, 10
    add $t3, $a1, $zero # loads from myArray
    li $t4, 32
    li $t0, 100 # sets the max amount of characters
    li $s6, 0 # counter that determines if the max amount of characters was reached
    li $t5, 9 # ASCII for tab
    li $t6, 0 # valid character counter
    li $t7, 0
    li $t8, 48 # ASCII for lowest character
    li $t9, 57 # ASCII for hightest possible non-letter digit ascii
    li $s0, 65 # ASCII for lowest possible capital letter ascii
    li $s1, 88 # ASCII for highest possible capital letter ascii # = X since N = 34
    li $s2, 97 # ASCII for lowest possible common letter ascii
    li $s3, 120 # ASCII for highest possible common letter ascii = x since N = 34
    add $s5, $a0, $zero
    j loop

loop:
    bgt $s6,$t0, invalidStatement # max number of characters is greater than 100
    bgt $t6,$t1, invalidStatement # number of valid characters is greater than 20
    lb $s4, 0($t3) # gets a character of the string
    beq $t6, $t7, leadChar # character could be considered leading
    beq $s4, $t4, trailingChar # character is equal to space
    beq $s4, $t5, trailingChar # character is equal to tab
    beq $s4, $t2, valid # newline comes before a invalid character is entered
