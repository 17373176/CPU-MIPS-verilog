.data 		#设置初始地址，在下一个可用地址中存储在数据段中的后续项
	
.text #在下一个可用的添加中存储在文本段中的后续项（指令）
		ori	$t1, $0, 0xffffffff
		lui	$t2, 0x7fff
		ori	$t2, $t2, 0xffff
		add 	$t0, $t1, $t2
	
