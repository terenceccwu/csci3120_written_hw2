# Equivalent code fragment expressed in Java-like syntax
# int foo = 100;
# int [] A;
# int [] B;
# A = new int [10];
# B = new int [foo];

addi $sp, $sp, -4  # Follow the convention of the lecture note
                   # for the stack machine where $sp points
                   # to the next location in the stack.
addi $sp, $sp, -12 # Reserve space to for foo, A, and B
li   $a0, 100      # foo is at $sp+12
sw   $a0, 12($sp)
sw   $0, 8($sp)    # A (address of A) is at $sp+8
sw   $0, 4($sp)    # B (address of B) is at $sp+4

# To allocate space for A[]
li $a0, 44 # 10 elements, 4 bytes each, plus 4 bytes for length
li $v0, 9  # syscall with service 9 = allocate space on heap
syscall

# address of the allocated space is now in $v0
sw $v0, 8($sp) # store address of A

# TODO: Insert code to initialize all elements of A to zeroes and set
# its length to 10.

li $t1, 10	# size of array A
sw $t1, 0($v0)	# set the size of A

A_initialize:
	li $t0, 1               # set the start index of for-loop
A_ini_loop:
	bgt $t0, $t1, A_exit    # go to branch exit if $t0 > $t1
	
	addi $v0, $v0, 4        # go to the address of the current element
	sw $zero, 0($v0)        # set the element to be 0
	
	addi $t0, $t0, 1        # increase the index
	j A_ini_loop            # jump to the beginning of the loop
	
A_exit: nop
	
# TODO: Insert code here to allocate space for B[], assign the
# address of the allocated space to B, initialize all of its
# elements to zeroes, and set its length to the value of "foo".

# To allocate space for B[]
lw $t1, 12($sp)	  # size of array B = foo
mul $a0, $t1, 4   # foo * 4 bytes
addi $a0, $a0, 4  # plus 4 bytes for length
li   $v0, 9       # syscall with service 9 = allocate space on heap
syscall

lw $t1, 12($sp)	# size of array B = foo
sw $t1, 0($v0)	# set the size of B

B_initialize:
	li $t0, 1               # set the start index of for-loop
B_ini_loop:
	bgt $t0, $t1, B_exit    # go to branch exit if $t0 > $t1
	
	addi $v0, $v0, 4        # go to the address of the current element
	sw $zero, 0($v0)        # set the element to be 0
	
	addi $t0, $t0, 1        # increase the index
	j B_ini_loop            # jump to the beginning of the loop
	
B_exit: nop

# termination of the program
li $v0, 10
syscall
