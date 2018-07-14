# ############################################################### 
# Matthew Buchanan # 409
# CS312
# Program 1                                                         
# ###############################################################

.data
	MSG_1:	.asciiz	"Please enter the number of credit hours completed at SIUE [0, 280]. "
	ERR_1:	.asciiz	"You made an invalid input for the credit hours earned at SIUE. Enter a valid input for the credit hours earned at SIUE [0, 280]. "
	MSG_2:	.asciiz	"Please enter the number of credit hours transferred from other academic institutions [0, 36]. "
	ERR_2:	.asciiz	"You made an invalid input for the credit hours transferred from another institution. Enter a valid input for the credit hours earned at another institution [0, 36]. "
	MSG_3:	.asciiz "You are a freshman."
	MSG_4:	.asciiz	"You are a sophomore"
	MSG_5:	.asciiz "You are a junior"
	MSG_6:	.asciiz	"You are a senior"
	NEW_LINE:	.asciiz "\n"

.text
.globl main

main:
	j message_1			#jump to start

message_1:
	li $v0, 4			# system call to print string
	la $a0, MSG_1 			#load message one into reg $a0
	syscall
	j input_1			#jump to input_1	
	
input_1:	
	li $t0, 280			#load the upper bound into temp reg $t0
	li $v0, 5			# system call take input
	syscall
	
	#### if (input < 0 || input > 280) then jump to error_1 ####
	bltz $v0, error_1
	bgt $v0, $t0, error_1

	#### else jump to input_2 ####
	move $s0, $v0			#store input in reg $s0 if conditions met
	j message_2			#jump to message_2

error_1:
	li $v0, 4			#system call to print string
	la $a0, ERR_1			#load error message one
	syscall
	j input_1			#jump back to input_1

message_2:
	li $v0, 4			# system call to print string
	la $a0, MSG_2 			#load message two into reg $a0
	syscall
	j input_2			#jump to input_2

input_2:
	li $t1, 36 			#load the upper bound into temp reg $t1
	li $v0, 5			#system call take input
	syscall
	
	#### if (input < 0 || input > 36) then jump to error_2 ####
	bltz $v0, error_2
	bgt $v0, $t1, error_2

	#### else jump to final_calc ####
	move $s1, $v0			#store input in reg $s1 if conditions met
	j final_calc			#jump to final_calc
	
error_2:
	li $v0, 4			#system call to print string
	la $a0, ERR_2			#load error message two
	syscall
	j input_2			#jump back to input_2
	
final_calc:
	add $s2, $s0, $s1		#add up total credit hours and put in reg $s2
	li $t0, 29			#store upper bound for freshman in $t0
	li $t1, 59			#store upper bound for sophomore in $t1
	li $t2, 89			#store cutoff point for junior/senior in $t2

	li $v0, 4              		# system call #4 - print a message
        la $a0, NEW_LINE       		# specify new line
        syscall

	ble $s2, $t0, freshman
	ble $s2, $t1, sophomore
	ble $s2, $t2, junior
	bgt $s2, $t2, senior

freshman:
	li $v0, 4			#system call to print string
	la $a0, MSG_3			#load error message two
	syscall
	jr $31 

sophomore:
	li $v0, 4			#system call to print string
	la $a0, MSG_4			#load error message two
	syscall
	jr $31

junior:
	li $v0, 4			#system call to print string
	la $a0, MSG_5			#load error message two
	syscall
	jr $31

senior:
	li $v0, 4			#system call to print string
	la $a0, MSG_6			#load error message two
	syscall
	jr $31
		


	

	
	