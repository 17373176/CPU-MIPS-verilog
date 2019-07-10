.data		# 全局变量和栈（局部、临时变量）
		arraya: .space 256   # apply array storage room 8*8
		arrayb: .space 256
		#stack: .space 16
		space: .asciiz " "		
		enter: .asciiz "\n"
.text		# 程序指令
			# input s0=n
		#la		$sp, stack
		li		$v0, 5				# read n
		syscall
		move	$s0, $v0			# s0=n
			# input arraya,t0=i,t1=n*n,t2=index,t5=address a[][]
		la		$t5, arraya		# load address of array
		li 	$t0, 0				# i=0
		mul	$t1, $s0, $s0	# content of t1 = lo
		mflo	$t1
		jal	loop_input		# jump to loop
			# input arrayb,t0=i,t2=index,t5=address b[][]
		la		$t5, arrayb		# load address of array
		li 	$t0, 0				# i=0
		jal	loop_input		# jump to loop_input and store$ra
		j		main				# jump to mainFUNC
	loop_input:	
		li		$v0, 5				# read a[][]/b[][]
		syscall
		sw		$v0, 0($t5)
		addi	$t5, $t5, 4	# incurrent address
		addi	$t0, $t0, 1		# i++
		bne	$t0, $t1, loop_input	# if t0!=t1, go on
		jr		$ra					# jump go on
			# main function
	main:
			# loop, t0=i,t1=j,t2=k, s1=a[][],s2=b[][],s3=c[][]
		li		$t0, 0				# i=0
		li		$t1, 0				# j=0
		j  	for_i				# first for
			# for_i
	for_i:
		jal	for_j				# second for
		li		$t1, 0				# j=0
		addi	$t0, $t0, 1		# i++
		jal	print_enter		# jump to print_enter
		bne	$t0, $s0, for_i	# if i!=n, go on
		j		end				# jump to end
			# for_j
	for_j:
		li		$t2, 0				# k=0
		li		$t5, 0				# t5=c
		sw		$ra, -4($sp)		# store $ra
		jal	for_k				# third for
		jal	print				# jump to print
		addi	$t1, $t1, 1		# j++
		lw		$ra, -4($sp)
		bne	$t1, $s0, for_j # if j!=n, go on
		jr		$ra					# return to for_i
	for_k:	# t3=a,t4=b,t5=c
		la		$s1, arraya		# load address of arraya
		la		$s2, arrayb		# load address of arrayb
		li		$t3, 0				
		li		$t4, 0
			# address a,b,c		
		mul	$t3, $s0, $t0	# t3=n*i
		mflo	$t3
		add	$t3, $t3, $t2	# t3+=k
		sll	$t3, $t3, 2		# t3=k*4
		add	$s1, $s1, $t3	# incurrent a
		mul	$t4, $s0, $t2	# t4=n*k
		mflo	$t4
		add	$t4, $t4, $t1	# t4+=j
		sll	$t4, $t4, 2		# t4=j*4
		add	$s2, $s2, $t4	# incurrent b
		lw		$t3, 0($s1)
		lw		$t4, 0($s2)
		mul	$t3, $t3, $t4	# a*b
		mflo	$t3
		add	$t5, $t5, $t3	# c+=a*b
		addi	$t2, $t2, 1		# k++
		bne	$t2, $s0, for_k # if k!=n, go on
		jr		$ra					# return to for_j
	print:
		add  	$a0, $t5, $0		# print c[][]
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
		
