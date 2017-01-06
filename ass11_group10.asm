#group 10
# Apurv Kumar : 14CS10006
# Shubham Sharma :14CS30034
# Assignment 11: to find fibonacci strings recursively

	.data
msg:    .asciiz "Enter an integer m (no less than 2): "
msg1:   .asciiz "\nS["
msg2:   .asciiz "]:"
msg3:   .asciiz "\n++++++++Fibonacci Words (step-by-step) are :\n\nS[0]:0\nS[1]:01"
	
	.text
	.globl main
main:
      li $v0,4
	  la $a0,msg
	  syscall
	  
	  li $v0,5
	  syscall
	  
	  move $s0,$v0
	  
	  li $s1,0
	  
	  li $s2,1
	  li $s3,1
	  
loop :	
	bge $s1,$s0,done
	
	move $t0,$s3
	addu $s3,$s3,$s2
	move $s2,$t0
	
	addi $s1,$s1,1
	
	j loop

done:
	move $fp,$sp
	mulou $s2,$s3,4
	subu $sp,$sp,$s2
	move $s1,$sp
	
	li $t0,0
	sw $t0,0($s1)
	
	li $t0,1
	sw $t0,4($s1)
	
	sub $sp,$sp,8
	
	move $s2,$sp
	
	li $t0,2
	sw $t0,0($s2)
	
	li $t0,1
	sw $t0,4($s2)
	
	li $v0,4
	la $a0,msg3
	syscall
	
	li $a0,2
	move $a1,$s0
	move $a2,$s1
	move $a3,$s2
	
	jal fibWord
	
	j exit
	

fibWord :
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0,$a0
	move $t1,$a1
	move $t2,$a2
	move $t3,$a3
	move $s4,$t2
	
	lw $t4,0($t3)
	lw $t5,4($t3)
	
	bgt $t0,$t1,done2
	
	move $t7,$t2
	
	mul $s3,$t4,4
	
	addu $t7,$t7,$s3
	
	li $t6,0
	
loop1 :
	bge $t6,$t4,done1
	
	lw $s5,0($t2)
	sw $s5,0($t7)
	
	addi $t7,$t7,4
	addi $t2,$t2,4
	addi $t6,$t6,1
	
	j loop1
	
done1 :
	move $t6,$t4
	addu $t4,$t5,$t4
	move $t5,$t6
	
	sw $t4,0($t3)
	sw $t5,4($t3)
	
fibWord_return:
	li $v0,4 								#print msg1
	la $a0,msg1
	syscall

	li $v0,1 								
	move $a0,$t0
	syscall

	li $v0,4 								#print msg2
	la $a0,msg2
	syscall
	
	li $t6,0
	move $t2,$s4
	
loop2 :
	bge $t6,$t4,done2.1
	
	li $v0,1 								
	lw $a0,0($t2)
	syscall
	
	addi $t2,$t2,4
	addi $t6,$t6,1
	j loop2

done2.1:
	addi $t0,$t0,1
	move $a0,$t0
	move $a1,$t1
	move $a2,$s4
	move $a3,$t3
	
	jal fibWord
	
done2:
	lw $ra 0($sp) 
	addi $sp,$sp,4
	jr $ra
	
	
exit : 
	move $sp,$fp				
	li $v0,10								
	syscall