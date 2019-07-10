.data

.text	
		ori	$t0, $0, 0x0000	
		ori	$a0, $0, 1
		ori	$a1, $0, 2
		ori	$a2, $0, 1
		beq	$a0, $a1, for_1
		beq	$a0, $a2, for_2
		addu	$a0, $0, $0
	for_1:
		sw		$a0, 0($t0)
	for_2:
		sw		$a1, 4($t0)
		lw		$t1, 4($t0)
		addu	$t0, $t1, $a1
		
