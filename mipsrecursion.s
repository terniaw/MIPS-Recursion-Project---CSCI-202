# Ternia Wilson
# 02894922 % 11 = 8
# 8 + 26 = Base 34

.data  # data declaration section
    myMessage: .asciiz "Please enter a string of up to 100 characters: "
    myArray: .space 101 # creating space for the users input
    invalidMessage: .asciiz "Invalid input\n"
    array: .word 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 # creates an array of 20 elements


.text
main:

    li $v0, 8 #accepts user input
    la $a0, myArray
    li $a1, 100 #specify the length the user can input
    syscall
    
    lw $t0, myArray # loads the word in $t0
    sub $sp, $sp, 12 # moves the pointer for stack
    sw $t0, 4($sp) # adds the input string to the stack
    la $a0, array # loads the array
    la $a1, myArray
    
    jal Valid_Str # jumps to subprogram A
    add $t1, $v0, $zero
    li $v0, 1
    move $a0, $t1
    syscall # prints the result of the decimal equivalent to the base 35 number
    li $v0, 10
    syscall # tell the system to end the program
    
Valid_Str:
    sw $ra, 0($sp)
    li $t1, 20
    li $t2, 10
    add $t3, $a1, $zero
    li $t4, 32
    li $t0, 100 # Max amount of characters
    li $s6, 0 # counter to determine if max characters have been reached
    li $t5, 9 # Tab ASCII code
    li $t6, 0 # counter for valid characters
    li $t7, 0
    li $t8, 48 # Lowest character
    li $t9, 57 # Highest possible no.
    li $s0, 65 # Lowest capital letter
    li $s1, 88 # Highest possible capital letter (X)
    li $s2, 97 # Lowest possible lowercase letter
    li $s3, 120 # Highest possible lowercase letter (x)
    add $s5, $a0, $zero
    j loop
    
loop:
    bgt $s6,$t0, Invalid # If no. of chars > 100
    bgt $t6,$t1, Invalid # If no. of chars > 100
    lb $s4, 0($t3)
    beq $t6, $t7, Leading
    beq $s4, $t4, Trailing
    beq $s4, $t5, Trailing
    beq $s4, $t2, valid

check:
    blt $s4, $t8, Invalid # If ASCII char is < 48
    bgt $s4, $t9, Nondigit # If ASCII char > 57
    addi $s4, $s4, -48
    sb $s4, 0($s5)
    addi $s5, $s5, 1 # Increments the address of array
    addi $t3, $t3, 1
    addi $t6, $t6, 1
    addi $s6, $s6, 1
    j loop
        
Leading: # Checks to see if the leading character is a tab or a space
    beq $s4, $t4, Skips
    beq $s4, $t5, Skips
    j check

Skips: # Skips character
    addi $t3, $t3, 1
    addi $s6, $s6, 1
    j loop
    
Trailing: # Checks to see if the trailing characters are tabs or spaces and removes them
    addi $t3, $t3, 1
    addi $s6, $s6, 1
    lb $s4, 0($t3)  # Gets the element
    bgt $s6,$t0, Invalid #Moves to Invalid if the no. of char > 100
    beq $s4, $t2, valid
    bne $s4, $s4, Nonspace
    j Trailing

Nonspace:
    bne $s4, $t5, Invalid # if character after space for trailing is not a tab or space then print invalid
    j Trailing # returns to check the next character for trailing tab or space

Invalid: # Prints invalid input
    li $v0, 4
    la $a0, invalidMessage # prints "Invalid Input"
    syscall
    
    li $v0, 10
    syscall # Ends program
    
Nondigit:
    blt $s4, $s0, Invalid
    bgt $s4, $s1, Noncapital
    addi $s4, $s4, -55
    sb $s4, 0($s5)
    addi $s5, $s5, 1
    addi $t3, $t3, 1
    addi $t6, $t6, 1
    addi $s6, $s6, 1
    j loop
    
Noncapital:
    blt $s4, $s2, Invalid
    bgt $s4, $s3, Invalid
    addi $s4, $s4, -87
    sb $s4, 0($s5)
    addi $s5, $s5, 1
    addi $t3, $t3, 1
    addi $t6, $t6, 1
    addi $s6, $s6, 1
    j loop
    
valid:
    sub $s5, $s5, $t6
    li $t0, 34
    li $t1, 100000
    li $t5, 0
    add $t1, $zero, $zero
    li $t2, 1
    
recursion:
    beq $t6, $t2, baseCase
    lb $t4, 0($s5)
    add $t1, $t1, $t4
    mult $t1, $t0
    mflo $t1
    addi $t6, $t6, -1
    addi $s5, $s5, 1
    j recursion
    
baseCase:
    lb $t4, 0($s5)
    add $t1, $t1, $t4
    add $v0, $zero, $t1
    jr $ra
