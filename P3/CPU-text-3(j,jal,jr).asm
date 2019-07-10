.data

.text	
		ori	$t0, $0, 0x0000	
		ori	$a0, $0, 0xffff
		ori	$a1, $0, 2
		j		for_2
		addu	$a0, $0, $0
	for_1:
		sw		$a0, 0($t0)
		jr		$ra
	for_2:
		sw		$a1, 4($t0)
		jal	for_1
		lw		$t1, 4($t0)
		addu	$t0, $t1, $a1
