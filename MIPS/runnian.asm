.data		# 全局变量和栈（局部、临时变量）
		input_information: .asciiz "Pleas input an integer:\n"
		output_information: .asciiz "The answer is: \n"
		satck: .space 10		# apply stack storage room
		TRUE: .asciiz "1"
		FALSE: .asciiz "0"
.text		# 程序指令
			# s0=year, t3=year%4||year%100||year%400, s1=condition,是print 1，否print 0/
			# input an integer 
		li		$v0, 5				# read an integer
		syscall
		move	$s0, $v0			# s0=year
		addi  $t0, $zero, 4	# t0=4
		addi	$t1, $zero, 100 # t1=100
		addi	$t2, $zero, 400 # t2=400
		# year%4
		div	$s0, $t0			# s0/t0,set LO to quotient and HI to remainder (use mfhi to access HI, mflo to access LO)
		mfhi	$t3					# access t3=HI
		move  $s1, $t3			# create condition
		beq	$s1, $zero, if_100 # year%4=0
		nop						# delay
		j		if_400			# jump to if_400
		nop						# delay
	if_100:
		# year%100
		div	$s0, $t1			# s0/t1,set LO to quotient and HI to remainder (use mfhi to access HI, mflo to access LO)
		mfhi	$t3					# access t3=HI
		move  $s1, $t3			# create condition
		bne	$s1, $zero, print_1 # year%100!=0
		nop						# delay
		j		if_400			# jump to if_400
		nop						# delay
	if_400:
		# year%400
		div	$s0, $t2			# s0/t2,set LO to quotient and HI to remainder (use mfhi to access HI, mflo to access LO)
		mfhi	$t3					# access t3=HI
		move  $s1, $t3			# create condition
		beq	$s1, $zero, print_1 # year%400=0
		nop						# delay
		j		print_0
		nop						# delay
	print_1:
		la		$a0, TRUE			# print 1
		li		$v0, 4				# print
		syscall
		j		if_end			# jump to if_end
		nop						# delay
	print_0:
		la  	$a0, FALSE		# print 0
		li		$v0, 4
		syscall
		j		if_end
		nop						# delay
	if_end:
		li		$v0, 10			# finish the program
		syscall
		