.data

.text		# CPU-text file-1
		# ori
		ori	$a0, $0, 123
		ori	$a1, $0, 456
		# lui
		lui	$a2, 234
		# add
		addu	$s0, $a0, $a1
		addu	$s1, $a0, $a2
		# sub
		subu	$s2, $a1, $a0
		subu	$s3, $a0, $a1
		# sw
		ori	$t0, $0, 0x0000
		sw		$a0, 0($t0)
		sw		$a1, 4($t0)
		# lw
		lw		$a0, 0($t0)
		lw		$a1, 4($t0)
		sw		$a0, 4($t0)
		sw		$a1, 0($t0)