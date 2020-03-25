#------------------------------------------------------------------------
# Created by:  Hawamdah, Ahmad
#              ahawamda
#              10 Dec 2019
#
# Assignment:  Lab 5: Subroutines
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
#
# Description: Library of subroutines used to convert an array of
#              numerical ASCII strings to ints, sort them, and print
#              them.
#
# Notes:       This file is intended to be run from the Lab 5 test file.
#------------------------------------------------------------------------

.text

j  exit_program                # prevents this file from running
                               # independently (do not remove)

#------------------------------------------------------------------------
# MACROS
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# print new line macro

.macro lab5_print_new_line
    addiu $v0 $zero   11
    addiu $a0 $zero   0xA
    syscall
.end_macro


#------------------------------------------------------------------------
# print string

.macro lab5_print_string(%str)

    .data
    string: .asciiz %str

    .text
    li  $v0 4
    la  $a0 string
    syscall

.end_macro

#------------------------------------------------------------------------
# add additional macros here


#------------------------------------------------------------------------
# main_function_lab5_19q4_fa_ce12:
#
# Calls print_str_array, str_to_int_array, sort_array,
# print_decimal_array.
#
# You may assume that the array of string pointers is terminated by a
# 32-bit zero value. You may also assume that the integer array is large
# enough to hold each converted integer value and is terminated by a
# 32-bit zero value
#
# arguments:  $a0 - pointer to integer array
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - minimum element in array (32-bit int)
#             $v1 - maximum element in array (32-bit int)
#-----------------------------------------------------------------------
# REGISTER USE
# $s0 - pointer to int array
# $s1 - double pointer to string array
# $s2 - length of array
#-----------------------------------------------------------------------

.text
main_function_lab5_19q4_fa_ce12: nop

    subi  $sp    $sp   16       # decrement stack pointer
    sw    $ra 12($sp)           # push return address to stack
    sw    $s0  8($sp)           # push save registers to stack
    sw    $s1  4($sp)
    sw    $s2   ($sp)

    move  $s0    $a0            # save ptr to int array
    move  $s1    $a1            # save ptr to string array

    move  $a0    $s1            # load subroutine arguments
    jal   get_array_length      # determine length of array
    move  $s2    $v0            # save array length

                                # print input header

    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nInput string array\n")

    subi  $sp    $sp   8	# push the arguments in a registers onto the stack
    sw    $a0  8($sp)           # to save their original value before jumping to
    sw    $a1  4($sp)		# print_str_array


                                # load subroutine arguments
    jal   print_str_array       # print array of ASCII strings

    lw    $a0  8($sp)           # load the arguments back onto the the registers from the stack
    lw    $a1  4($sp)
    addi  $sp    $sp   8



    subi  $sp    $sp   8	# push the arguments in a registers onto the stack
    sw    $a0  8($sp)           # to save their original value before jumping to
    sw    $a1  4($sp)		# print_str_array


    move $a0, $s2		# saving the $s registers into $a regsiters to be used lat
    move $a1, $s1
    move $a2, $s0
                                # load subroutine arguments
    jal   str_to_int_array      # convert string array to int array

    lw    $a0  8($sp)
    lw    $a1  4($sp)
    addi  $sp    $sp   8


    move $a1, $s0

    subi  $sp    $sp   8	# push the arguments in a registers onto the stack
    sw    $a0  8($sp)           # to save their original value before jumping to
    sw    $a1  4($sp)		# sort_array

                                # load subroutine arguments
    jal   sort_array            # sort int array


    lw    $a0  8($sp)
    lw    $a1  4($sp)
    addi  $sp    $sp   8



    subi  $sp    $sp   8	# save min and max values from array
    sw    $v0  8($sp)
    sw    $v1  4($sp)

                                # print output header
    lab5_print_new_line
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nSorted integer array\n")


    subi  $sp    $sp   8
    sw    $a0  8($sp)
    sw    $a1  4($sp)
                                # load subroutine arguments
    jal   print_decimal_array   # print integer array as decimal
                                # save output values
    lw    $a0  8($sp)
    lw    $a1  4($sp)
    addi  $sp    $sp   8
    lab5_print_new_line


    lw    $v0  8($sp)
    lw    $v1  4($sp)		# loading $v values back after printing
    addi  $sp    $sp   8


    lw    $ra 12($sp)           # pop return address from stack
    lw    $s0  8($sp)           # pop save registers from stack
    lw    $s1  4($sp)
    lw    $s2   ($sp)
    addi  $sp    $sp   16       # increment stack pointer

    jr    $ra                   # return from subroutine

#-----------------------------------------------------------------------
# print_str_array
#
# Prints array of ASCII inputs to screen.
#
# arguments:  $a0 - array length (optional)
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
#
#-----------------------------------------------------------------------

.text
print_str_array: nop

    lw $t0 0($a1)               # load the word of $a1 into $t0
    move $a0 $t0                # store the word loaded into $a0
    li $v0 4                    # print the word/ASCII string
    syscall
    li $v0 11
    li $a0, 0x20                # Print a space
    syscall

    lw $t0 4($a1)               # load the word of $a1 into $t0
    move $a0 $t0                # store the word loaded into $a0
    li $v0 4                    # print the word/ASCII string
    syscall
    li $v0 11
    li $a0, 0x20                # Print a space
    syscall

    lw $t0 8($a1)               # load the word of $a1 into $t0
    move $a0 $t0                # store the word loaded into $a0
    li $v0 4                    # print the word/ASCII string
    syscall
    li $v0 11
    li $a0, 0x20                # Print a space
    syscall

    jr  $ra

#-----------------------------------------------------------------------
# str_to_int_array
#
# Converts array of ASCII strings to array of integers in same order as
# input array. Strings will be in the following format: '0xABCDEF00'
#
# i.e zero, lowercase x, followed by 8 hexadecimal digits, with A - F
# capitalized
#
# arguments:  $a0 - array length (optional)
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
#             $a2 - pointer to integer array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
#
#-----------------------------------------------------------------------

.text
str_to_int_array: nop

#Change the ASCII strings to integer values

	#la $a2, test_int_array

	addi $t0, $t0, 0	# intializing $t registers
	addi $t1, $t1, 0

	la $t0 0($a1)           # start by loading the first argument into $t5
	lw $t1 ($t0)

	move $a0, $t1		# store the first argument into $a0

	subi $sp $sp 4		# save $ra before jumping into the stack
	sw $ra ($sp)

	jal str_to_int		# jump and link to the address at label str_to_int

	lw $ra ($sp)		# retrieving $ra from the stack
	addi $sp $sp 4

   	sw $v0, 0($a2)		# storing the result $v0 into the array


   	addi $t0, $t0, 0	# reintializing $t registers
	addi $t1, $t1, 0

	la $t0 4($a1)           # loading the 2nd argument into $t5
	lw $t1 ($t0)

	move $a0, $t1		# store the 2nd argument into $a0

	subi $sp $sp 4		# save $ra before jumping into the stack
	sw $ra ($sp)

	jal str_to_int		# jump and link to the address at label str_to_int

	lw $ra ($sp)		# retrieving $ra from the stack
	addi $sp $sp 4

   	sw $v0, 4($a2)		# storing the result $v0 into the array


	la $t0 8($a1)           # loading the 3rd argument into $t5
	lw $t1 ($t0)

	move $a0, $t1		# store the 3rd argument into $a0

	subi $sp $sp 4		# save $ra before jumping into the stack
	sw $ra ($sp)

	jal str_to_int		# jump and link to the address at label str_to_int

	lw $ra ($sp)		# retrieving $ra from the stack
	addi $sp $sp 4

   	sw $v0, 8($a2)		# storing the result $v0 into the array

    jr   $ra

#-----------------------------------------------------------------------
# str_to_int
#
# Converts ASCII string to integer. Strings will be in the following
# format: '0xABCDEF00'
#
# i.e zero, lowercase x, followed by 8 hexadecimal digits, capitalizing
# A - F.
#
# argument:   $a0 - pointer to first character of ASCII string
#
# returns:    $v0 - integer conversion of input string
#-----------------------------------------------------------------------
# REGISTER USE
#
#-----------------------------------------------------------------------


.text
str_to_int:
li $t1, 268435456	# 16^7 to be used for shifting the bits
addi $t5, $zero, 0	# intialize $t registers
addi $t4, $zero, 0
addi $t5, $zero, 0
StringToInt2: NOP
    beq $t4, 8, endThing	# check if $t4 reached 4 characters
    addi $t4, $t4, 1		# increment loop counter
    lb $t2, 2($a0)		# loading one byte at a time
    addi $a0 $a0 1
    blt $t2, 65, subNum        	# check if the ASCII byte is less than 65, loop to operations in subNum
    bge  $t2, 65, subChar	# check if the ASCII byte is more than 65, loop to operations in charNum


subNum:        # First operations loop if the byte read if less than 65 for numbers 1-9
    sub $t2, $t2, 48    # subtract 48
    mul $t2, $t2, $t1   # multiply the result to 16^7
    div $t1, $t1, 16    # divide the 16^7 by 16 for shifting
    add $t5, $t5, $t2   # increment the loop
    j StringToInt2      # loop back to the First conversion loop

subChar:        # First operations loop if the byte read if more than 65 for char A-F
    sub $t2, $t2, 55    # subtract 55
    mul $t2, $t2, $t1   # multiply the result to 16^7
    div $t1, $t1, 16    # divide the 16^7 by 16 for shifting
    add $t5, $t5, $t2   # increment the loop
    j StringToInt2      # loop back to the First conversion loop

endThing:

    add $v0, $t5, $zero	# save the result into $v0
    jr $ra

#-----------------------------------------------------------------------
# sort_array
#
# Sorts an array of integers in ascending numerical order, with the
# minimum value at the lowest memory address. Assume integers are in
# 32-bit two's complement notation.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    $v0 - minimum element in array
#             $v1 - maximum element in array
#-----------------------------------------------------------------------
# REGISTER USE
#
#-----------------------------------------------------------------------

.text
sort_array: nop
#la $a2, test_int_array

SortInts1: NOP    # First loop comparing 3 register $f4, $f6, and $f8
	addi $t0, $zero, 0	#1st argument
	addi $t1, $zero, 0	#2nd argument
	addi $t2, $zero, 0	#3rd argument

	addi $t5, $zero, 0	# Min Element
	addi $t6, $zero, 0	# Middle Element
	addi $t6, $zero, 0	# Max Element

	lw $t0, ($a1)		# loading the frist argument into $t0
	lw $t1, 4($a1)		# loading the 2nd argument into $t1
	lw $t2, 8($a1)		# loading the 3rd argument into $t2


  	bgt $t0, $t1, minF1    	# if 1st argument is less than the second one
    			   	# branch to minimumFalse1 branch

    	bgt $t0, $t2,  minFF1  	# if 1st argument is less than the third one
		 	    	# branch to minimumFalseFalse1 branch

    	move $t5, $t0      	# if 1st argument is the smallest, store in $t5 "Hex"
    	j SortInts2      	# Branch to sorting the two left, $t1 and $t1

    	minF1:             # minimumFalse1 branch "Checking $t1 and $t2"
        	bgt $t1, $t2, minFF1    # compare $t1 and $t2
        	        		# branch to minimumFalseFalse1 branch

        	move $t5, $t1     	# if 2nd argument is the smallest, store in $t5 "Hex"
        	j SortInts3      	# Branch to sorting the two left, $t0 and $t2

    	minFF1:            # minimumFalseFalse1 branch
        	move $t5, $t2     	# stores the third argument being the smallest into $t5 "Hex"
        	j SortInts4      	# Branch to sorting the two left, $t0 and $t2
ExitSortInts1:    # end of the first loop comparing 3 register $f4, $f6, and $f8

SortInts2: NOP    # Second loop comparing 2 register $t1 and $t2

    bgt $t1, $t2, minF2     	# compare $f6 and $f8
    		           	# branch to minimumFalse2 branch if Coprocessor is 0
    move $t6, $t1     		# store the 2nd argument into $t1 "Float"
    move $t7, $t2      		# store the 3rd argument into $t2 "Float"


    j end             		# exit and branch to Print

    minF2:             		 # minimumFalse2 branch
        move $t6, $t2       		# store the 3rd argument into $t6 "Hex"
       	move $t7, $t1       		# store the 2nd argument into $t7 "Hex" "CHECK"
        j end             		# exit and branch to Print
ExitSortInts2:    # end of Second loop comparing 2 register $f6 and $f8

SortInts3: NOP    # Third loop comparing 2 register $t0 and $t2
    bgt $t0, $t2, minF3     	# compare $f4 and $f8
			    	# branch to minimumFalse3 branch

    move $t6, $t0      		# store the 1st argument into $t6 "Hex"
    move $t7, $t2       	# store the 3rd argument into $t7 "Hex"
    j end             		# exit and branch to Print

    minF3:              # minimumFalse3 branch
        move $t6, $t2       		# store the 3rd argument into $t6 "Hex"
        move $t7, $t0      		# store the 1st argument into $t7 "Hex"
        j end             		# exit and branch to Print
ExitSortInts3:    # end of third loop comparing 2 register $f4 and $f8

SortInts4: NOP    # Fourth loop comparing 2 register $t0 and $t2
    bgt  $t0, $t2, minF4     	# compare $f4 and $f6
   		  	    	# branch to minimumFalse4 branch

    move $t6, $t0      	 	# store the 1st argument into $t6 "Hex"
    move $t7, $t1       	# store the 2nd argument into $t7 "Hex"
    j end             		# exit and branch to Print
    minF4:              # minimumFalse3 branch
        move $t6, $t1       # store the 2nd argument into $t6 "Hex"
        move $t7, $t0       # store the 1st argument into $t7 "Hex"
        j end             # exit and branch to Print
ExitSortInts4:    # end of fourth loop comparing 2 register $t0 and $t2

end:
	move $v0, $t5	# save the results into $t registers
	move $v1, $t7

	sw $v0, ($a1)	# store the results back into the array
	sw $t6, 4($a1)
	sw $v1, 8($a1)

    jr   $ra

#-----------------------------------------------------------------------
# print_decimal_array
#
# Prints integer input array in decimal, with spaces in between each
# element.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
#
#-----------------------------------------------------------------------

.text
print_decimal_array: nop

	subi $sp $sp 4		# save $ra before jumping into the stack
	sw $ra 4($sp)


	addi $t0, $t0, 0	# intializing $t registers
	addi $t1, $t1, 0

	la $t0 0($a1)           # load the 1st argument inro $t1
	lw $t1 ($t0)

	move $a0, $t1		# move it to $a0 to be used as a subroutine argument

	jal print_decimal	# jump and link to print_decimal branch

   	li $a0, 0x20		# print a space
    	li $v0, 11
   	syscall

   	addi $t0, $t0, 0	# reintializing $t registers
	addi $t1, $t1, 0

	la $t0 4($a1)           # load the 2nd argument into $t1
	lw $t1 ($t0)

	move $a0, $t1		# move it to $a0 to be used as a subroutine argument

	jal print_decimal	# jump and link to print_decimal branch


	li $a0, 0x20		# print a space
    	li $v0, 11
   	syscall

   	addi $t0, $t0, 0	# reintializing $t registers
	addi $t1, $t1, 0

	la $t0 8($a1)           # start by loading the 3rd argument into $t1
	lw $t1 ($t0)

	move $a0, $t1		# move it to $a0 to be used as a subroutine argument


	jal print_decimal	# jump and link to print_decimal branch

	lw $ra 4($sp)
	addi $sp $sp 4


    jr   $ra

#-----------------------------------------------------------------------
# print_decimal
#
# Prints integer in decimal representation.
#
# arguments:  $a0 - integer to print
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
#
#-----------------------------------------------------------------------
.data
.align 2
array1: .space 32
.text
print_decimal: nop

	addi $t0 $zero  0	# intializing $t registers
	addi $t1 $zero  0
	addi $t2 $zero  0
	addi $t3 $zero  0

	beqz, $a0, loopPos	# check if the argument is positive, jump to loopPos branch
	blez, $a0, loopNeg	# check if the argument is negative, jump to loopNeg branch

loopPos:

	rem $t0, $a0, 10		# store the remainder in $t0 "extracting one digit at a time"
	div $a0, $a0, 10		# divide the argument by 10, "move the decimal point for the next digit"
	addi $t0, $t0, 48		# add 48 to the ascii value to get the integer
	sub $sp, $sp , 4		# push that digit onto the stack
	sw $t0, 0($sp)
	addi $t1, $t1, 1		# increment a loop counter, to be used in printing later
	beq $a0, 0, printarrayPos 	# when the remainder is 0, branch to printarrayPos
j loopPos

loopNeg:
	abs $a0, $a0			# get the positive version of the argument
	rem $t0, $a0, 10		# store the remainder in $t0 "extracting one digit at a time"
	div $a0, $a0, 10		# divide the argument by 10, "move the decimal point for the next digit"
	addi $t0, $t0, 48		# add 48 to the ascii value to get the integer
	sub $sp, $sp , 4		# push that digit onto the stack
	sw $t0, 0($sp)
	addi $t1, $t1, 1		# increment a loop counter, to be used in printing later
	beq $a0, 0, printarrayNegOut 	# when the remainder is 0, branch to printarrayNegOut outter loop
j loopNeg

#eggprog:

printarrayPos:
    lw $a0, 0($sp)		# loading one digit at a time in the form of a byte
    addi $sp, $sp , 4 		# printing that digit
    li $v0, 11
    syscall
    sub $t1, $t1, 1		# decrement the loop counter created in in loopPos
    beq $t1, $zero, endmylife	# exit when the counter is 0, "determines the # of digits"
j printarrayPos

printarrayNegOut:
    li $a0, 45			# printing the character '-'
    li $v0, 11
    syscall
printarrayNeg:
    lw $a0, 0($sp)		# loading one digit at a time in the form of a byte
    addi $sp, $sp , 4
    li $v0, 11			# printing that digit
    syscall
    sub $t1, $t1, 1		# decrement the loop counter created in in loopNeg
    beq $t1, $zero, endmylife	# exit when the counter is 0, "determines the # of digits"
j printarrayNeg

endmylife:
    jr   $ra

#-----------------------------------------------------------------------
# exit_program (given)
#
# Exits program.
#
# arguments:  n/a
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $v0: syscall
#-----------------------------------------------------------------------

.text
exit_program: nop

    addiu   $v0  $zero  10      # exit program cleanly
    syscall

#-----------------------------------------------------------------------
# OPTIONAL SUBROUTINES
#-----------------------------------------------------------------------
# You are permitted to delete these comments.

#-----------------------------------------------------------------------
# get_array_length (optional)
#
# Determines number of elements in array.
#
# argument:   $a0 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - array length
#-----------------------------------------------------------------------
# REGISTER USE
#
#-----------------------------------------------------------------------

.text
get_array_length: nop

    addiu   $v0  $zero  3       # replace with /code to
                                # determine array length
    jr      $ra

#-----------------------------------------------------------------------
# save_to_int_array (optional)
#
# Saves a 32-bit value to a specific index in an integer array
#
# argument:   $a0 - value to save
#             $a1 - address of int array
#             $a2 - index to save to
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
#
#-----------------------------------------------------------------------
