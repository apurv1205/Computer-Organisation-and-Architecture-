# Group 10
# Apurv Kumar-14CS10006
# Shubham Sharma-14CS30034
# Assignment 10 - to print the sum matrix C for two matrices A and B after reading their row and column lengths



	.data
msg:    .asciiz ", "																	#stings to be used in printing
msg1:   .asciiz "Enter three positive integers s, m and n: "
msg2:   .asciiz "\n"
msg3:   .asciiz "|"
msg4:   .asciiz " |\n"
msg5:   .asciiz " "
msg6:   .asciiz "A : "
msg7:   .asciiz "B : "
msg8:   .asciiz "C : " 
msg9:   .asciiz "\n...Adding matrices A and B using addMat subroutine\n\n"


	.text
	.globl main
main:	
	li $v0,4								#prompting for msg1
	la $a0,msg1
	syscall

	li $v0,5								#reading s (seed)
	syscall
	move $s0,$v0

	li $v0,5								#reading m
	syscall
	move $s1,$v0

	li $v0,5								#reading n
	syscall
	move $s2,$v0

	move $fp,$sp							#remembering stack entry point stored in $fp into $sp
	subu $fp,$fp,4

	li $t0,4								#allocating desired space for A,B and C matrices
	mulou $t1,$s2,$s1
    mulou $t0,$t0,$t1

    move $s6,$t0							#$s6 stores the memory size to be allocated for the matrices

    subu $sp,$sp,$t0						#A
    move $s3,$sp
    move $s7,$s3

    subu $sp,$sp,$t0						#B
    move $s4,$sp
    move $s8,$s4

    subu $sp,$sp,$t0						#C
    move $s5,$sp

    li $t0,1								#looping index for 'loop'

    sw $s0,0($s3)							#initialing A[0][0] with seed
    addi $s3,$s3,4

    addi $t1,$s0,10

    sw $t1,0($s4)							#initialing B[0][0] with seed + 10
    addi $s4,$s4,4

    mulou $s6,$s1,$s2						#$s6 now stores m * n

loop :	
	bge $t0,$s6,done						#if looping index >= m*n, jump to 'done'

	lw $t1,-4($s3)							#calculating the next matrix element value based on the previous value as per the problem statement
	li $t2,330
	mulou $t1,$t1,$t2

	addi $t1,$t1,100

	li $t3,2303
	remu $t1,$t1,$t3

	sw $t1,0($s3)							#storing the value in A matrix


	lw $t1,-4($s4)							#calculating the next matrix element value based on the previous value as per the problem statement
	li $t2,330
	mulou $t1,$t1,$t2

	addi $t1,$t1,100

	li $t3,2303
	remu $t1,$t1,$t3

	sw $t1,0($s4)							#storing the value in B matrix


	addi $t0,$t0,1
	addi $s3,$s3,4
	addi $s4,$s4,4

	j loop 									#while loop


done :
	li $v0,4								#print msg6
	la $a0,msg6
	syscall

	move $a0,$s1 							#arguements storing for printMat for A
	move $a1,$s2
	move $a2,$s7
	sw   $ra, -4($sp)  

    jal printMat							#call printMat for A

    li $v0,4 								#print newline
	la $a0,msg2
	syscall


	li $v0,4								#print msg7
	la $a0,msg7
	syscall

    move $a0,$s1 							#arguements storing for printMat for B
	move $a1,$s2
	move $a2,$s8
	sw   $ra, -4($sp)  

    jal printMat							#call printMat for B

	move $a0,$s6 							#arguements storing for addMat for C
	move $a1,$s7
	move $a2,$s8
	move $a3,$s5
	sw   $ra, -4($sp)

	jal addMat								#call addMat which updates C as A+B

	li $v0,4 								#print newline
	la $a0,msg2
	syscall

	li $v0,4								#print msg7
	la $a0,msg9
	syscall

	li $v0,4								#print msg7
	la $a0,msg8
	syscall

	move $a0,$s1 							#arguements storing for printMat for C
	move $a1,$s2
	move $a2,$s5
	sw   $ra, -4($sp)  

    jal printMat							#call printMat for C
    	
    j exit									#jump to 'exit'



printMat : 
	move $t2,$a0 							#stroing arguements in t registers
	move $t3,$a1
	move $t4,$a2	
	li $t0,0 								#looping index for 'loop1'

	li $v0,4           						#print newline
	la $a0,msg2
	syscall

	j loop1 								#jump to 'loop1'

loop1 : 
	bge $t0,$t2,done1 						#if looping index >= m, jump to 'done1'

	li $v0,4 								#print msg7
	la $a0,msg3
	syscall

	li $t1,0 								#looping index for 'loop2' (nested loop)
	j loop11

loop11 :
	bge $t1,$t3,loop12 						#if looping index >= n, jump to 'loop12'

	li $v0,4 								#print msg7
	la $a0,msg5 
	syscall

	li $v0,1 								#printing the current value in register $t4
	lw $a0,0($t4)
	syscall

	addi $t1,$t1,1							#incrementing looping index
	addi $t4,$t4,4							#incrementing $t4 by 4
	j loop11								#nested while loop


loop12:
	li $v0,4 								#print msg7
	la $a0,msg4
	syscall

	addi $t0,$t0,1 							#incrementing looping index
	j loop1 								#jump to loop1

done1 :		
	jr $ra  								#just return



addMat :
	move $t0,$a0 							#stroing arguements in t registers
	move $t1,$a1
	move $t2,$a2
	move $t3,$a3
	j loop2 								#jump to loop2

loop2 :
	beqz $t0,done1 							#if looping index==0, jump to done1
	lw $t5,0($t1)							#loading value in address contained in $t1 into $t5
	lw $t6,0($t2)							#loading value in address contained in $t2 into $t6

	addu $t7,$t5,$t6 						#adding values in $t5 and $t6 and storing in $t7

	sw $t7,0($t3) 							#saving $t7 in address stored in $t3 

	addi $t1,$t1,4							#incrementing $t1 by 4 to point to next matrix element in A 
	addi $t2,$t2,4							#incrementing $t1 by 4 to point to next matrix element in B
	addi $t3,$t3,4							#incrementing $t1 by 4 to point to next matrix element in C
	subu $t0,$t0,1							#updating looping index

	j loop2 								#while loop

exit : 
	move $sp,$fp							#reseting the stack pointer removing all locally stored variables (Matrices)
	li $v0,10								#syscall parameter for exiting the program
	syscall