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
    li $s1, 88 # ASCII for highest possible capital letter ASCII # = X since N = 34
    li $s2, 97 # ASCII for lowest possible common letter ascii
    li $s3, 120 # ASCII for highest possible common letter ASCII = x since N = 34
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

check:
    blt $s4, $t8, invalidStatement # breaks if ACSII is less than 48
    bgt $s4, $t9, notDigit # breaks if ASCII is more than 57
    addi $s4, $s4, -48 # ASCII digit align with digits
    sb $s4, 0($s5) # stores the character in a new string
    addi $s5, $s5, 1 # adds to address of the new array
    addi $t3, $t3, 1 # adds to address of the input string
    addi $t6, $t6, 1 # increments the amount of valid characters
    addi $s6, $s6, 1 # increments max number of characters
    j loop
    
leadChar:
    beq $s4, $t4, tabOrSpace # if leading charater is a space
    beq $s4, $t5, tabOrSpace # if leading character is a tab
    j check # check if is valid, not a tab or space

tabOrSpace: # skips character and goes to the next one
    addi $t3, $t3, 1 # adds to address of the input string
    addi $s6, $s6, 1 # adds to max number of characters
    j loop

trailingChar:  #fucntion for checking if the rest of the code is all trailing tabs or spaces
    addi $t3, $t3, 1 #moves to next byte
    addi $s6, $s6, 1 # increments max number of characters
    lb $s4, 0($t3)  # gets character of the string
    bgt $s6,$t0, invalidStatement # if max number of characters is greater than 100
    beq $s4, $t2, valid # if only trailing tabs are spaces are found before newline
    bne $s4, $s4, notSpace # if character is not a space
    j trailingChar # returns to check next character for trailing tab or space

notSpace:
    bne $s4, $t5, invalidStatement # character after space for trailing is not a tab or space then print invalid
    j trailingChar #returns to check the next character for trailing tab or space

    invalidStatement: # prints invalid input and exists file
    li $v0, 4
    la $a0, invalidMessage # prints out "Invalid Input" to use
    syscall
    
    li $v0, 10
    syscall # tell the system to end the program
    
notDigit:
    blt $s4, $s0, invalidStatement # breaks if ASCII of character is < 65
    bgt $s4, $s1, notCapital # breaks if ASCII of character is > 88
    addi $s4, $s4, -55 # makes the ASCII for digit align with capital letters
    sb $s4, 0($s5) # stores the character in a new string
    addi $s5, $s5, 1 # increments the address of the new array
    addi $t3, $t3, 1 # increments the address of the input string
    addi $t6, $t6, 1 # increments the amount of valid characters
    addi $s6, $s6, 1 # increments max number of characters
    j loop

notCapital:
    blt $s4, $s2, invalidStatement # breaks if ASCII of character is < 97
    bgt $s4, $s3, invalidStatement # breaks if ASCII of character is > 121
    addi $s4, $s4, -87 # makes the ASCII for digit align with common letters
    sb $s4, 0($s5) # stores the character in a new string
    addi $s5, $s5, 1 # increments the address of the new array
    addi $t3, $t3, 1 # increments the address of the input string
    addi $t6, $t6, 1 # increments the amount of valid characters
    addi $s6, $s6, 1 # increments max number of characters
    j loop

valid:
    sub $s5, $s5, $t6 # position address to first character
    li $t0, 35 # loads the base number
    li $t1, 100000 # the final recursive product sum lo
    li $t5, 0 # the final recursive product sum hi
    add $t1, $zero, $zero
    li $t2, 1 # set equal to 1

recursion:
    beq $t6, $t2, baseCase # branch if only one character is left
    lb $t4, 0($s5) # loads the address of the last character
    add $t1, $t1, $t4 # adds it to the total
    mult $t1, $t0 # multiplies the result by the base number
    mflo $t1
    addi $t6, $t6, -1
    addi $s5, $s5, 1
    j recursion

baseCase:
    lb $t4, 0($s5) # loads the address of the last character
    add $t1, $t1, $t4 # adds to total

    add $v0, $zero, $t1
    jr $ra

