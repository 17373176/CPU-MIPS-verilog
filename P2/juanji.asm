.data		# 全局变量和栈（局部、临时变量）
		arraya: .space 484   # apply array storage room 11*11
		arrayb: .space 484
		space: .asciiz " "		
		enter: .asciiz "\n"
.text		# 程序指令
			# input s0=n1,s1=m1,s2=n2,s3=m2
		li		$v0, 5				# read n1
		syscall
		move	$s0, $v0			# s0=n1
		li		$v0, 5				# read m1
		syscall
		move	$s1, $v0			# s1=m1
		li		$v0, 5				# read n2
		syscall
		move	$s2, $v0			# s2=n2
		li		$v0, 5				# read m2
		syscall
		move	$s3, $v0			# s3=m2
			# input arraya,t0=i,t1=n1*m1,t5=address a[][]
		la		$t5, arraya		# load address of array
		li 	$t0, 0				# i=0
		mult	$s0, $s1			# content of t1
		mflo	$t1					# t1=s0*s1
		jal	loop_input		# jump to loop
			# input arrayb,t0=i,t1=n2*m2,t5=address b[][]
		la		$t5, arrayb		# load address of array
		li 	$t0, 0				# i=0
		mult	$s2, $s3			# t1=s2*s3
		mflo	$t1			
		jal	loop_input		# jump to loop_input and store$ra
		j		main				# jump to mainFUNC
	loop_input:	
		li		$v0, 5				# read a[i][j]/b[][]
		syscall
		sw		$v0, 0($t5)		# store
		addi	$t5, $t5, 4		# incurrent address
		addi	$t0, $t0, 1		# i++
		bne	$t0, $t1, loop_input	# if t0!=t1, go on
		jr		$ra					# jump go on
			# main function, t0=i,t1=j,s4=n1-n2,s5=m1-m2
	main:
		li		$t0, 0				# i=0
		sub	$s4, $s0, $s2	# s4=n1-n2
		addi	$s4, $s4, 1
		sub	$s5, $s1, $s3	# s5=m1-m2
		addi	$s5, $s5, 1
		j	for_i				# first loop
			# first loop 
	for_i:
		li		$t1, 0				# j=0
		jal	for_j				# second loop
		jal	print_enter		# print "/n"
		addi	$t0, $t0, 1		# i++
		bne	$t0, $s4 for_i	# if i!=n1-n2,go on
		j		end				# jump to end
			# second loop, t2=x,t3=y, s6=c[][], t4=n2+i,t5=m2+j
	for_j:
		add	$t2, $0, $t0		# x=i
		li		$s6, 0				# c=0
		add	$t4, $t0, $s2	# t4=n2+i
		add	$t5, $t1, $s3	# t5=m2+j
		sw		$ra, -8($sp)		# store $ra
		jal	for_x				# jump to third loop
		jal	print				# print c
		addi	$t1, $t1, 1		# j++
		lw		$ra, -8($sp)		# load $ra
		bne	$t1, $s5, for_j	# if j!=m1-m2, go on
		jr		$ra					# return
			# third loop
	for_x:
		add	$t3, $0, $t1		# y=j
		sw		$ra, -4($sp)		# store $ra
		jal	for_y				# jump to firth loop
		addi	$t2, $t2, 1		# x++
		lw		$ra, -4($sp)		# load $ra
		bne	$t2, $t4, for_x	# if x!=n2+i, go on
		jr		$ra					# return
			# firth loop,t7=a[][],t8=b[][],t6=address,t9=address
	for_y:
		la		$t7, arraya		# load address of a[][]
		mult	$t2, $s1			# x*m1
		mflo	$t6					# t6=x*m1
		add	$t6, $t6, $t3	# t6+=y
		sll	$t6, $t6, 2		# t6*=4
		add	$t7, $t7, $t6	# incurrent address
		lw		$t9, 0($t7)		# t9=a[][]
		la		$t8, arrayb		# load address of b[][]
		sub	$t6, $t2, $t0	# t6=x-i
		mult	$t6, $s3			# (x-i)*m2
		mflo	$t6	
		add	$t6, $t6, $t3	# (x-i)*m2+y
		sub	$t6, $t6, $t1	# (x-i)*m2+y-j
		sll	$t6, $t6, 2		# t6*=4
		add	$t8, $t8, $t6	# incurrent address
		lw		$t6, 0($t8)		# t6=a[][]
		mult	$t9, $t6			# t9*t6
		mflo	$t6					# =a*b
		add	$s6, $s6, $t6	# c+=a*b
		addi	$t3, $t3, 1		# y++
		bne	$t3, $t5, for_y	# if y!=m2+j, go on
		jr		$ra					# return 
	print:
		add  	$a0, $s6, $zero	# print c[][]
		li		$v0, 1
		syscall
		la		$a0, space		# print " "
		li		$v0, 4
		syscall
		jr		$ra					# return
	print_enter:
		la		$a0, enter		# print "\n"
		li		$v0, 4
		syscall
		jr		$ra					# return
	end:
		li		$v0, 10			# finish the program
		syscall
