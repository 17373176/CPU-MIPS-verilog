.data		# 全局变量和栈（局部、临时变量）
		arraya: .space 1600  # apply array storage room 20*20
.text		# 程序指令
			# input s0=n
		li		$v0, 5				# read an integer
		syscall
		move	$s0, $v0			# read s0=n
		beq	$s0, 1, print_1 # if n==1, print_1
			# input array, t0=i,t1=address of a[],t5=flag
		la		$t1, arraya		# load address
		li 	$t0, 0				# i=0
		li		$t5, 1				# flag=1
		jal	loop_input		# jump to loop_input
		j		main				# jump to main func
			# loop input
	loop_input:
		li		$v0, 12			# read a character
		syscall
		sw		$v0, 0($t1)		# store a[]
		addi	$t1, $t1, 4		# incurrent address
		addi	$t0, $t0, 1		# i++
		bne	$t0, $s0, loop_input # if i!=n, go on
		jr		$ra					# return
			# main function,t0=i,t5=flag,t6=n/2
	main:
		li		$t6, 2				# t6=2
		div	$s0, $t6			# n/2
		mflo	$t6
		li		$t0, 0				# i=0
		jal	for				# jump to for
		bne	$t5, $zero, print_1 # if flag=1, print_1
		j		end
			# for func, t2=address of a[1],t3=address of a[2]
	for:
		sll	$t2, $t0, 2		# t2=t0*4
		lw		$t2, 0($t2)		# load a[1]
		addi	$t3, $s0, -1		# t3=n-1
		sub	$t3, $t3, $t0	# t3-=i
		sll	$t3, $t3, 2		# t3*=4
		lw		$t3, 0($t3)		# load a[2]
		bne	$t2, $t3, print_0 # if !=, jump to print_0
		addi	$t0, $t0, 1		# i++
		bne	$t0, $t6, for	# if i!=n/2, go on
		jr		$ra					# return
	print_1:
		li		$a0, 1				# print "1"
		li		$v0, 1
		syscall
		j		end				# return
	print_0:
		la		$a0, 0				# print "0"
		li		$v0, 1
		syscall
		j		end				# return
	end:
		li		$v0, 10			# finish the program
		syscall