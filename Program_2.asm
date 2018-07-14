# ############################################################### 
# Matthew Buchanan # 409
# CS312
# Program 2                                                         
# ###############################################################

.data
	MSG_1:		.asciiz "Enter the first number (0, 50)."
	MSG_2:		.asciiz	"Enter the second number (0, 50)."
	ERR_1:		.asciiz "The number entered is less than or equal to 0. Enter another number."
	ERR_2:		.asciiz "The number entered is greater than or equal to 50. Enter another number."
	ERR_3:		.asciiz "The number entered is less than or equal to 0. Enter another number."
	ERR_4:		.asciiz "The number entered is greater than or equal to 50. Enter another number."
	NEW_LINE:	.asciiz "\n"

.text
.globl main

main:
	j message_1

message_1:
	li $v0, 4			# system call to print string
	la $a0, MSG_1 			#load message one into reg $a0
	syscall
	j input_1

input_1:
	li $t0, 50			#load the upper bound into temp reg $t0
	li $v0, 5			# system call take input
	syscall

	#### if (input <= 0 || input >= 50) then jump to error_1 ####
	blez $v0, error_1
	bge $v0, $t0, error_2

	#### else jump to input_2 ####
	move $s0, $v0			#store input in reg $s0 if conditions met
	j message_2			#jump to message_2

error_1:
	li $v0, 4              		# system call #4 - print a message
        la $a0, NEW_LINE       		# specify new line
        syscall		

	li $v0, 4			#system call to print string
	la $a0, ERR_1			#load error message one
	syscall
	j input_1			#jump back to input_1

error_2:
	li $v0, 4              		# system call #4 - print a message
        la $a0, NEW_LINE       		# specify new line
        syscall		

	li $v0, 4			#system call to print string
	la $a0, ERR_2			#load error message two
	syscall
	j input_1			#jump back to input_2

message_2:
	li $v0, 4			# system call to print string
	la $a0, MSG_2 			#load message one into reg $a0
	syscall
	j input_2

input_2:
	li $t0, 50			#load the upper bound into temp reg $t0
	li $v0, 5			# system call take input
	syscall

	#### if (input <= 0 || input >= 50) then jump to error_2 ####
	blez $v0, error_3
	bge $v0, $t0, error_4

	#### else prep the counter and result regs, and jump to the while loop ####
	move $s1, $v0			#store input in reg $s1 if conditions met
	move $s2, $zero			#use reg $s2 as our counter
	move $s3, $zero			#reg $s3 will hold the resulting product
	j while				#jump to while

error_3:
	li $v0, 4              		# system call #4 - print a message
        la $a0, NEW_LINE       		# specify new line
        syscall		

	li $v0, 4			#system call to print string
	la $a0, ERR_3			#load error message three
	syscall
	j input_2			#jump back to input_2

error_4:
	li $v0, 4              		# system call #4 - print a message
        la $a0, NEW_LINE       		# specify new line
        syscall		

	li $v0, 4			#system call to print string
	la $a0, ERR_4			#load error message four
	syscall
	j input_2			#jump back to input_2

#### repeated addition of reg $s0 with itself, with val of reg #s1 as parameter == $s0 * $s1 ####
#### reg $s2 holds the counter, reg $s3 hold the product
while:	
	beq $s1, $s2, end		#compare the parameter: reg $s1 to the counter: reg $s2
	add $s3, $s3, $s0		#add reg $s0 to itself, using reg $s3 to hold the running total
	addi $s2, 1			#increment the counter reg $s2
	j while				#repeat until equality of parameter and counter

#### print the resulting product ####
end:	
	li $v0, 4              		# system call #4 - print a message
        la $a0, NEW_LINE       		# specify new line
        syscall	

	li $v0, 1
	move $a0, $s3
	syscall
	jr $31
	
	