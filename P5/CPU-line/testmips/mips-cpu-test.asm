# lui, ori, addu, subu, sw, lw, j, jal, jr
.text	
		lui	$2, 0x1234
		ori	$1, $0, 1234
		ori	$1, $1, 0xfff
		ori	$1, $1, 1123
		ori	$1, $1, 1281
		addu	$1, $1, $2
		addu	$1, $1, $2
		addu	$1, $1, $2
		addu	$1, $1, $1
		lui	$1, 0
		sw		$3, 0($1)
		lw		$1, 0($1)
		sw		$1, 0($0)
		lw		$1, 4($0)
		sw		$3, 0($1)
		lui	$2, 0x0000
		jal	loop
		ori	$3, $0, 256
		addu  $3, $3, $2
		j		end
		lui	$2, 0
		sw		$3, 0($2)
	loop:
		ori	$2, $2, 512
		subu	$3, $2, $0
		sw		$3, 4($2)
		addu	$3, $3, $3
		sw		$3, 4($3)
		lw		$4, 0($3)
		addu	$4, $3, $4
		jr		$ra
		nop
	end: