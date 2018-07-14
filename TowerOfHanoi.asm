################################################################ 
# Matthew Buchanan # 409
# CS312
# Tower of Hanoi Recursive Program                                                    
################################################################

.data
	MSG_1:				.asciiz "   Moving a disc from peg "
	MSG_2:				.asciiz " to peg "
	MSG_3:				.asciiz "Moving "
	MSG_4:				.asciiz " discs ..."
	MSG_5:				.asciiz "Peg 1 is the starting peg, Peg 2 the temporary peg, and Peg 3 the finish peg."
	MSG_6:				.asciiz "Process Completed!"
	NEW_LINE:			.asciiz "\n"

.text
.globl main

main:
	li $t1, 3			#set number of disks here	
	
	##### start intro message #####
	li $v0, 4
	la $a0, MSG_3
	syscall	
			
	li $v0, 1
	move $a0, $t1
	syscall

	li $v0, 4
	la $a0, MSG_4
	syscall

	li $v0, 4              		
        la $a0, NEW_LINE       		
        syscall

	li $v0, 4
	la $a0, MSG_5
	syscall	

	li $v0, 4              		
        la $a0, NEW_LINE       		
        syscall
	####### end intro message #######				

	li $a1, 1			#start peg
	li $a2, 2			#temp peg
	li $a3, 3			#destination peg
	
	subu $sp, $sp, 20		#create a 20 byte stack frame
	sw $ra, 0($sp)			#save reg $ra
	sw $t1, 4($sp)			#save reg $t1 == number of disks
	sw $a1, 8($sp)			#save reg $a1 == start peg
	sw $a2, 12($sp)			#save reg $a2 == temp peg
	sw $a3, 16($sp)			#save reg $a3 == destination peg

	jal towers			#call the towers subroutine
	
	lw $ra, 0($sp)			#restore reg $ra
	lw $t1, 4($sp)			#restore reg $t1 == number of disks
	lw $a1, 8($sp)			#restore reg $a1 == start peg
	lw $a2, 12($sp)			#restore reg $a2 == temp peg
	lw $a3, 16($sp)			#restore reg $a3 == destination peg
	addiu $sp, $sp, 20		#pop stack frame

	##### begin exit message #####
	li $v0, 4              		
        la $a0, NEW_LINE       		
        syscall

	li $v0, 4
	la $a0, MSG_6
	syscall		
	##### end exit message #######	
	
	jr $31				#exit

towers:					#push to stack
	subu $sp, $sp, 20		#create 20 byte stack frame
	sw $ra, 0($sp)			#save reg $ra
	sw $t1, 4($sp)			#save reg $t1
	sw $a1, 8($sp)			#save reg $a1 == start peg
	sw $a2, 12($sp)			#save reg $a2 == temp peg
	sw $a3, 16($sp)			#save reg $a3 == destination peg
	
step_one:
	beq $t1, $zero, pop		#base case / exit case
	subu $t1, 1			#decrement number of discs
	move $t2, $a2			
	move $a2, $a3			#swap temp and destination pegs
	move $a3, $t2
	jal towers			#first recursive call

#### begin output #####		
step_two:
	li $v0, 4
	la $a0, MSG_1
	syscall

	li $v0, 1
	move $a0, $a1
	syscall

	li $v0, 4
	la $a0, MSG_2
	syscall

	li $v0, 1
	move $a0, $a2
	syscall

	li $v0, 4              		
        la $a0, NEW_LINE       		
        syscall	
##### end output #######

step_three:				#load registers for second recursive call
	lw $a1, 12($sp)			
	lw $a2, 8($sp)
	lw $a3, 16($sp)
	jal towers

pop:					#pop the stack frame
	lw $ra, 0($sp)			#restore reg $ra
	lw $t1, 4($sp)			#restore reg $t1
	lw $a1, 8($sp)			#restore reg $a1 == start peg
	lw $a2, 12($sp)			#restore reg $a2 == temp peg
	lw $a3, 16($sp)			#restore reg $a3 == destination peg
	addiu $sp, $sp, 20		#pop stack frame
	jr $ra				#jump to return address

