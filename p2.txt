# // Equivalent code fragment expressed in Java-like syntax
# int sum(int [] n) {
#  return /* sum of elements in n[] … */
# }
# // In caller
# sum(B); // B can be a reference to an integer array or null.

.data
	# suppose the first element in the array denotes the size of the array
	list:	.word	14, 14, 12, 13, 5, 9, 11, 3, 6, 7, 10, 2, 4, 8, 1
.text


main:
	# "THE FRAME POINTER" (Textbook p.120)
	# "The old value of FP is saved in memory (in the frame)"
	sw $fp, 0($sp)
	# "and the old SP becomes the current frame pointer FP."
	move $fp, $sp
	addiu $sp, $sp, -4
	# Stack: | old $fp

	# Simulate the address of B[] at $sp+4
	la $a0, list
	sw $a0, 0($sp)	# store address to stack (as a local variable B[])
	addiu $sp, $sp, -4
	# Stack: &B[] | old $fp

	
	# TODO: Insert code to set up parameters and invoke the function
	lw $a0, 4($sp)  # load the local variable B[] ($sp+4) to $a0

	# "RETURN ADDRESSES" (Textbook p.123)
	# "A non-leaf procedure will then have to write it to the stack"
	sw $ra, 0($sp)
	addiu $sp, $sp, -4
	# Stack: old $ra, &B[] | old $fp

	# call function sum
	jal sum
	# After returning from the function call, the return value should
	# be kept in $a0.

	# RESTORE: restore return address from stack
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	# Stack: &B[] | old $fp
		
	li $v0, 1	# print out the result
	syscall 

	li $v0, 10	# terminate program
	syscall 

# TODO: Insert code for the function definition (You can use any
# approach to compute the sum of the elements)	
sum:
	# "THE FRAME POINTER" (Textbook p.120)
	# "The old value of FP is saved in memory (in the frame)"
	sw $fp, 0($sp)
	# "and the old SP becomes the current frame pointer FP."
	move $fp, $sp
	addiu $sp, $sp, -4
	# Stack: | main $fp , main $ra, &B[] | old $fp
	
	# the argument is stored in $a0
	la $s0, 0($a0)
	lw $t1, 0($a0)	# read the size of the array
	
	li $t0, 1	# initialize the starting index
	li $a0, 0	# initialize the sum to be 0, and $a0 is the return value
	
sum_loop:
	bgt $t0, $t1, exit_loop	# go to branch exit_loop if $t0 > $t1
	
	addi $s0, $s0, 4	# read the current item
	lw $t2, 0($s0)
	
	add $a0, $a0, $t2
	
	addi $t0, $t0, 1
	j sum_loop
	
exit_loop:
	# "THE FRAME POINTER" (Textbook p.120)	
	# "When f exits, it just copies FP back to SP"
	move $sp, $fp
	# "and fetches back the saved FP."
	lw $fp, 0($sp)
	addiu $sp, $sp, 4
	# Stack: main $ra, &B[] | old $fp

	jr $ra	# return
	
