.data		# 全局变量和栈（局部、临时变量）
		input_information: .asciiz "Pleas input n,m:\n"
		output_information: .asciiz "The answer is: \n"
		#satck: .space 10		# apply stack storage room
		array: .space 10000   # apply array storage room50*50
		space: .asciiz " "		
		enter: .asciiz "\n"
.text		# 程序指令
			# 按照输入顺序逆序输出,考虑存储数组和访问数组的问题
			
			# input s0=n,s1=m
		li		$v0, 5				# read n
		syscall
		move	$s0, $v0			# s0=n
		addi	$s0, $s0 ,1		# n++
		li		$v0, 5				# read m
		syscall
		move	$s1, $v0			# s1=m
		addi	$s1, $s1, 1		# m++
		
			# input array,t0=i,t1=j,t2=k,t3=a[i][j]
		li 	$t0, 1				# i=1
		li		$t1, 1				# j=1
		li		$t2, 0				# k=0
		j		loop_input		# jump to loop
		nop
		
			# s2 as base address of array,t4=incurrent address
		li		$v0, 5				# read a[1][1]
		syscall
		move	$s2, $v0			# s2=a[i][j]
		
	loop_input:
		li		$v0, 5				# read a[i][j]
		syscall
		move	$t3, $v0 
		addi	$t2, $t2, 4		# k+=4
		add	$t4, $t2, $s2	# address of a[i][j]
		sw		$t3, 0($t4)		# store a[i][j]
		addi	$t1, $t1, 1		# j++
		slt	$t3, $t1, $s1	# if t1<s1, t3=1
		bne	$t3, $zero, loop_input # go on input
		nop
									# if not
		addi	$t0, $t0, 1		# i++
		li		$t1, 1				# j=1
		slt	$t3, $t0, $s0	# if t0<s0, t3=1
		bne	$t3, $zero, loop_input # go on input
		nop
									# if not
			# loop output
		addi	$s0, $s0, -1		# n--
		addi	$s1	, $s1, -1		# m--
		add	$t0, $s0, $0		# i=n
		add	$t1, $s1, $0		# j=m
		j		loop_output		# input ending, jump to out
		nop
		
	loop_output:
		add	$t4, $t2, $s2	# access t4
		lw		$t3, 0($t4)		# store a[i][j]
		addi	$t2, $t2, -4		# k-=4
		bne	$t3, $zero, print # if !=0, jump to print
		nop
									# if not
		j		while				# go on
		nop
		
	while:
		addi	$t1	, $t1, -1		# j--
		bne	$t1, $zero, loop_output # if j!=0, go on
		nop
									# if not
		add	$t1, $s1, $0		# j=m
		addi	$t0, $t0, -1		# i--
		bne	$t0, $zero, loop_output # if t0!=0, go on
		nop
									# if not
		j		end				# jump end
		nop
		
	print:
		add  	$a0, $t0, $0		# print i
		li		$v0, 1
		syscall
		la		$a0, space 
		li		$v0, 4
		syscall
		add  	$a0, $t1, $0		# print j
		li		$v0, 1
		syscall
		la		$a0, space 
		li		$v0, 4
		syscall
		add  	$a0, $t3, $0		# print a[i][j]
		li		$v0, 1
		syscall
		la		$a0, enter
		li		$v0, 4
		syscall
			# loop print
		j		while				# go on
		nop

	end:
		li		$v0, 10			# finish the program
		syscall
		
