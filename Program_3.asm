# ############################################################### 
# Matthew Buchanan # 409
# CS312
# Program 3
# This program solves the present value equation for time in years                                                         
# ###############################################################

.data
	MSG_1:		.asciiz	"Enter the principle ($1~$500) "
	MSG_2:		.asciiz	"Enter the interest rate (0.01~0.5) "
	MSG_3:		.asciiz "Enter the target balance "
	ERR_1:		.asciiz	"The entered principal is less than $1. enter principle $1-$500 "
	ERR_2:		.asciiz	"The entered principal exceeds the limit. Enter principal $1-$500 "
	ERR_3:		.asciiz "The entered interest rate is not allowed. Enter an interest rate 0.01 - 0.5"
	ERR_4:		.asciiz	"The entered target balance must be greater than the principal. Enter a valid target balance "
	MSG_4:		.asciiz "It will take "
	MSG_5:		.asciiz " years to reach the target balance."
	NEW_LINE:	.asciiz "\n"
	ZERO:		.float	0.00
	ONE:		.float  1.00
	FIVEH:		.float	500.0
	HUNDTH:		.float	0.01
	HALF:		.float  0.5
	

.text
.globl main

main:
	j message_1				

message_1:
	li $v0, 4				# system call to print string
	la $a0, MSG_1 				#load message one into reg $a0
	syscall
	j input_1

input_1:
	li $v0, 6				#take a fp input to reg $f0
	syscall	
	
	#### store the input in fp reg $f1 ####
	la $a0, ZERO				#load 0.0 to reg $a0
	lwc1 $f1, ($a0)				#load $a0 into $f1
	add.s $f1, $f1, $f0			#load the input $f0 into $f1

	#### store the lower bound 1.0 in fp reg $f10 ####
	la $a0, ONE
	lwc1 $f10, ($a0)

	#### store the upper bound 500.0 in fp reg $f11 ####
	la $a0, FIVEH
	lwc1 $f11, ($a0)
	
	#### if (input < 1.0 || input > 500.0) then jump to error_1 or error_2 ####
	c.lt.s $f1, $f10
	bc1t error_1
	c.le.s $f1, $f11
	bc1f error_2
	
	#### else jump to message_2
	j message_2

error_1:
	li $v0, 4              			# system call #4 - print a message
        la $a0, NEW_LINE       			# specify new line
        syscall

	li $v0, 4				# system call to print string
	la $a0, ERR_1 				#load message one into reg $a0
	syscall
	j input_1

error_2:
	li $v0, 4              			# system call #4 - print a message
        la $a0, NEW_LINE       			# specify new line
        syscall

	li $v0, 4				# system call to print string
	la $a0, ERR_2 				#load message one into reg $a0
	syscall
	j input_1

message_2:
	li $v0, 4				# system call to print string
	la $a0, MSG_2 				#load message two into reg $a0
	syscall
	j input_2

input_2:
	li $v0, 6				#take a fp input to reg $f0
	syscall	
	
	#### store the input in fp reg $f2 ####
	la $a0, ZERO				#load 0.0 to reg $a0
	lwc1 $f2, ($a0)				#load $a0 into $f2
	add.s $f2, $f2, $f0			#load the input $f0 into $f2

	#### store the lower bound .01 in fp reg $f10 ####
	la $a0, HUNDTH
	lwc1 $f10, ($a0)

	#### store the upper bound 0.5 in fp reg $f11 ####
	la $a0, HALF
	lwc1 $f11, ($a0)
	
	#### if (input < 0.01 || input > 0.5) then jump to error_3 ####
	c.lt.s $f2, $f10
	bc1t error_3
	c.le.s $f2, $f11
	bc1f error_3
	
	#### else jump to message_3
	j message_3

error_3:
	li $v0, 4              			# system call #4 - print a message
        la $a0, NEW_LINE       			# specify new line
        syscall

	li $v0, 4				# system call to print string
	la $a0, ERR_3 				#load message one into reg $a0
	syscall
	j input_2				#jump back to input_2

message_3:
	li $v0, 4				# system call to print string
	la $a0, MSG_3 				#load message three into reg $a0
	syscall
	j input_3				#jump to input_3

input_3:
	li $v0, 6				#take a fp input to reg $f0
	syscall	
	
	#### store the input in fp reg $f3 ####
	la $a0, ZERO				#load 0.0 to reg $a0
	lwc1 $f3, ($a0)				#load $a0 into $f3
	add.s $f3, $f3, $f0			#load the input $f0 into $f3

	#### if (input >= principle ($f1)) then jump to error_4 ####
	c.le.s $f3, $f1
	bc1t error_4
	j final_prep

error_4:
	li $v0, 4              			# system call #4 - print a message
        la $a0, NEW_LINE       			# specify new line
        syscall

	li $v0, 4				# system call to print string
	la $a0, ERR_4 				#load message one into reg $a0
	syscall
	j input_3

#### prep fp reg $f4 to hold product temp, reg $s1 to hold N counter
final_prep:
	la $a0, ZERO
	lwc1 $f4, ($a0)
	li $s1, 0
	j final_calc

#### principle in fp reg $f1, interest in fp reg $f2, future value in fp reg $f3 ####
final_calc:
	c.lt.s $f3, $f1				
	bc1t result
	mul.s $f4, $f1, $f2
	add.s $f1, $f1, $f4
	addi $s1, 1				#increment N counter
	j final_calc

#### places N ($s1) into output register ($f12) and outputs it ####
result:
	li $v0, 4              			# system call #4 - print a message
        la $a0, NEW_LINE       			# specify new line
        syscall

	li $v0, 4				# system call to print string
	la $a0, MSG_4 				#load message one into reg $a0
	syscall
	
	li $v0, 1				# system call to print integer
	la $a0, ($s1)
	syscall

	li $v0, 4				# system call to print string
	la $a0, MSG_5				#load message one into reg $a0
	syscall

	jr $31					# end
