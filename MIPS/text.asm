.data

	.text
		addi	$t0, $0, 4
		addi	$t1, $0, 2
		mul	$t0,$t1,$t0
		sw		$t0, 0($t0)
		#mflo	$t0
		lw	$a0, 0($t0)
		li		$v0, 1
		syscall
