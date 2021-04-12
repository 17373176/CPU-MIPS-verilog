.data		# 全局变量和栈（局部、临时变量）
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
		add	$a0, $s0, $0		# $a0=n
		jal	factorial
		j		print
	factorial:
		addi	$sp, $sp, -8	
		sw		$a0, 4($sp)
		sw		$ra, 0($sp)
		li		$t0, 2				# t0=2
		slt	$t0, $a0, $t0	# n<=1?
		beq	$t0, $0, else	# no: go to else
		li		$v0, 1				# return 1
		addi	$sp, $sp, 8
		jr		$ra
	else:
		addi	$a0, $a0, -1		# n--
		jal	factorial
		lw		$a0, 4($sp)
		lw		$ra, 0($sp)
		addi	$sp, $sp, 8
		mul	$v0, $a0, $v0
		jr		$ra
 	print:
		add  	$a0, $v0, $zero	# print
		li		$v0, 1
		syscall
 	end:
		li		$v0, 10			# finish the program
		syscall
