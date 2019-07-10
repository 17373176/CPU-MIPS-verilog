.data		# 全局变量和栈（局部、临时变量）
		array: .space 32   # apply array storage room 11*11
		symbol: .space 32
		stack: .space 256
		space: .asciiz " "		
		enter: .asciiz "\n"
.text		# 程序指令
			# input s0=n
		la		$sp, stack		# load stack
		addi	$sp, $sp, 256
		li		$v0, 5				# read n
		syscall
		move	$s0, $v0			# s0=n
			# index & i maybe change, t0=i,每次用i的时候清零, a0=index
		li		$a0, 0				# index=0
		jal	Full				# jump to Full func
		j		end				# jump to end
			# Full func
	Full:
		li		$t0, 0				# i=0
		beq	$a0, $s0, output # if index>=n, output
		li		$t0, 0				# new i=0
		addi	$sp, $sp, -12	# adjust to create stack room
		sw		$a0, 8($sp)		# store index
		sw		$ra, 4($sp)		# store $ra
		sw		$t0, 0($sp)		# store i
		jal	for				# jump to for
		lw		$a0, 8($sp)
		lw		$ra, 4($sp)
		lw		$t0, 0($sp)
		addi	$sp, $sp,	12		# delete stack room
		jr		$ra					# return last func
			# loop func, t1=address s, t2=address a, s2=a[],s1=s[]
	for:
		la		$s1, symbol		# load s[]
		sll	$t1, $t0, 2		# t1=i*4
		add	$t1, $t1, $s1	# t1+=s1
		lw		$s1, 0($t1)		
		bne	$s1, $0, if		# if s[]!=0, go on		
		la		$s2, array
		sll	$t2, $a0, 2
		add	$s2, $t2, $s2
		addi	$t2, $t0, 1		# i+1
		sw		$t2, 0($s2)		# a[]=i+1
		li		$s1, 1				# s1=1
		sw		$s1, 0($t1)		# store s[]=1
		addi	$sp, $sp, -12
		sw		$a0, 8($sp)
		sw		$ra, 4($sp)
		sw		$t0, 0($sp)		# store i
		addi	$a0, $a0, 1		# index++
		jal	Full				# loop func
		lw		$a0, 8($sp)
		lw		$ra, 4($sp)
		lw		$t0, 0($sp)		# load i
		addi	$sp, $sp, 12
		la		$s1, symbol		# load s[]
		sll	$t1, $t0, 2		# t1=i*4
		add	$t1, $t1, $s1	# t1+=s1
		sw		$0, 0($t1)		# store s[]=0
		addi	$t0, $t0, 1		# i++
		bne	$t0, $s0, for	# if i!=n, go on
		j		end_for
	end_for:
		jr		$ra					# return last func
	if:
		addi	$t0, $t0, 1		# i++
		beq	$t0, $s0, end_for # if i==n, end_for
		j		for				# jump to for, go on
			# loop output ,t1=address,t2=a[]
	output:
		la		$t1, array		# load address
		sll	$t2, $t0, 2		# t2=i*4
		add	$t1, $t2, $t1	# t1+=t2
		lw		$t2, 0($t1)		# load a[]
		addi	$sp, $sp, -4
		sw		$ra, 0($sp)
		jal	print				# jump to print
		addi	$t0, $t0,1		# i++
		lw		$ra, 0($sp)
		addi	$sp, $sp, 4
		bne	$t0, $s0, output # if i!=n, go on
		addi	$sp, $sp, -4
		sw		$ra, 0($sp)
		jal	print_enter 	# if i=n, print enter 
		lw		$ra, 0($sp)
		addi	$sp, $sp, 4
		jr		$ra					# return last func
	print:
		add  	$a0, $t2, $zero	# print array[]
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
