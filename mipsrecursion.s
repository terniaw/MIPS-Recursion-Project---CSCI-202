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
