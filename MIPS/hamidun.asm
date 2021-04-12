.data		0x00000000		#基地址
			# 全局变量和栈（局部、临时变量）
	stack: .space 32		# apply stack storage room
	array: .space 200     # apply array storage room7*7*4
	vis: .space 32		   # size of vis
	
.text		# 程序指令
			# 考虑存储数组和访问数组的问题,输出1代表具有哈密顿回路，0代表不具有
			
			# input s0=n,s1=m,s2=flag=0
		li		$v0, 5				# read n
		syscall
		move	$s0, $v0			# s0=n
		li		$v0, 5				# read m
		syscall
		move	$s1, $v0			# s1=m
		li		$s2, 0				# s2=0
			# loop input
		li		$t2, 1				# t2=i边数
	loop_input:
		slt	$t0, $s1, $t2	# if m<i, t0=1
		bne	$t0, $zero, main # m<i, jump to main 
		nop
		li		$v0, 5				# read u
		syscall
		move	$t0, $v0			# t0=u
		li		$v0, 5				# read v
		syscall
		move	$t1, $v0			# t1=v
			# store a[u][v]=1 and a[v][u]=1, t3=首地址address of array
		la		$t3, array		# load address of array 
		li		$t4, 0				# t4=j,用来指下标，计算地址
		li		$t5, 1				# 存储为t5=1
			# address=(u-1)*8*4+(v-1)*4
		add	$t4, $t4, $t0	
		addi	$t4, $t4, -1
		sll	$t4, $t4, 3
		sll	$t4, $t4, 2
		addi	$t1, $t1, -1
		sll	$t1, $t1, 2
		add	$t4, $t4, $t1
			# store a[i][j]=1
		add	$t4, $t4, $t3
		sw		$t5, 0($t4)
			# address=(v-1)*8*4+(u-1)*4
		li		$t4, 0	
		add	$t4, $t4, $t1	
		addi	$t4, $t4, -1
		sll	$t4, $t4, 3
		sll	$t4, $t4, 2
		addi	$t0, $t0, -1
		sll	$t0, $t0, 2
		add	$t4, $t4, $t0
			# store a[j][i]=1
		add	$t4, $t4, $t3
		sw		$t5, 0($t4)
		addi	$t2, $t2, 1		# i+1
		j		loop_input		# go on input
		nop
		
			# main function
	main:
			# vis[]=0, t0=the first address, t1=i,t2=address,t3=8
		la		$t0, vis			# load address of vis
		li		$t1, 0				# i=0
		li		$t2, 0				# address=0
		li		$t3, 8				# t3=size=8
		j		set
		nop
	set:	# vis置零
		slt	$t4, $t1, $t3	# if i<size, t4=1
		beq	$t4, $zero, begin # if t4=0, jump to begin
		nop
									# if not
		add	$t4, $t0, $t2	# t4=vis[]
		sw		$0, 0($t4)		# vis[]=0
		addi	$t1, $t1, 1		# i++
		sll	$t2, $t1, 2		# address=i*4	
		j		set				# go on
		nop
		
			# s0=n,s1=m,s2=flag
	begin:
			# the first condition n==1$$m>=1
		beq	$s0, 1, cond_1 # if n=1, jump to cond_1
		nop
									# if not
		j		begin_2			# jump to begins_2
		nop
	cond_1:
			# if m>=1, flag=1, jump to print_1
		slt	$t0, $zero, $s1 # if 0<m, t0=1
		beq	$t0, 1, print_1 # if =1,jump to print_1
		nop
									# if not
			# if n==2&&m>=2
	begin_2:
		beq	$s0, 2, cond_2	# if n=2, jump to cond_2	
		nop					
									# if not
		j		cond_3			# jump to cond_3
		nop
	cond_2:
			# if m>=2, flag=1, jump to print_1
		addi	$t0, $zero, 1	# t0=1
		slt   $t1, $t0, $s1 # if 1<m, t1=1
		beq	$t1, 1, print_1 # if t1=1,jump to print_1
		nop
									# if not
			# if n!=2, jump cond_3							
		bne	$s0, 2, cond_3	# jump to cond_3
		nop
									# if not
		j		print_0			# jump to print_0
		nop

	cond_3:
			# 从顶点1开始到顶点1结束, $t1=j,s0=n,s1=m,s2=flag
		li		$t1, 1				# t0=j=1
	loop_for:
		slt	$t0, $s0, $t1	# if n<j,t1=1
		beq	$t0, $zero, for		# if t1=0,jump to for
		nop
									# if not
		j		print_0
		nop
			# loop to search a[1][j]
	for:
			# if t5=a[1][j]!=0
		la		$t3, array		# load address of array 
		la		$t3, 0($t3)		# load t3	
		li		$t0, 0				# address=t0
			# address=(j-1)*4
		add	$t0, $t0, $t1
		addi	$t0, $t0, -1
		sll	$t0, $t0, 2
		add	$t0, $t0, $t3
		la		$t5, 0($t0)		# load a[1][j]
		bne	$t5, $zero, if		# a[1][j]!=0,jump to if			
		nop
									# if not
		addi	$t1, $t1, 1		# j++
		j		loop_for			# go on
		nop
			# if vis[j]==0,digui
	if:
		la		$t2, vis			# load t0=address of vis[]
		li		$t0, 0				# address=t0
		add	$t0, $t0, $t1
		addi	$t0, $t0, -1
		sll	$t0, $t0, 2
		add	$t0, $t0, $t2
		la		$t5, 0($t0)		# load vis[j],记得存储t5=vis[j]，之后要清零
		beq	$t5, $zero, digui	# digui
		nop
									# if not
		addi	$t1, $t1, 1		# j++
		j		loop_for			# go on
		nop
		
	digui:
			# store j=$t1,$ra,$a0,$v0,$t5,(t0,t2,t3,t4,t6,t7可以用),参数j=t1=a0
		la		$a0, 0($t1)		# 参数传递
		jal	dfs				# 递归调用
		nop
			# vis[j]=0
		la		$t2, vis			# load t2=address of vis[]
		li		$t0, 0				# address=t0
		add	$t0, $t0, $t1
		addi	$t0, $t0, -1
		sll	$t0, $t0, 2
		add	$t0, $t0, $t2
		sw		$0, 0($t0)		# store vis[j]=0
		beq	$s2, 1, print_1	 # if flag=1, jump to print_1
		nop
		# if not
		addi	$t1, $t1, 1		# j++
		j		loop_for			# go on
		nop
		
			# dfs(j=$t1)
	dfs:
			# store j=$t1,$ra,$a0,返回值$v0,vis[j]=$t5,参数j=t1=a0
		la		$sp, stack
		addi	$sp, $sp, -20
		sw		$t1, 0($sp)		# store j to $sp	
		sw		$ra, 4($sp)		
		sw		$a0, 8($sp)	
		sw		$v0, 12($sp)	
		sw		$t5, 16($sp)	
			# if j=$a0=1, t0=k, t4=q,$t0和$t4不可以用
		li 	$t0, 0
		beq	$a0, 1, loop_vis # if a0=1, jump t0 loop_vis
		nop
									# if not
			# vis[j]=1
		la		$t2, vis			# load t2=address of vis[]
		li		$t3, 0				# address=t3
		add	$t3, $t3, $a0	# t3=j
		addi	$t3, $t3, -1
		sll	$t3, $t3, 2
		add	$t3, $t3, $t2
		li		$t7, 1				# 置1
		sw		$t7, 0($t3)		# store vis[j]=1
		li 	$t4, 1				# q=1
			# loop 
		j		secceed
		nop
			# load j=$t1,$ra,$a0,$v0,$t5
		lw		$t1, 0($sp)		# load from $sp to $t1
		lw		$ra, 4($sp)		
		lw		$a0, 8($sp)	
		lw		$v0, 12($sp)	
		lw		$t5, 16($sp)	
		addi	$sp, $sp, 20		# restore $sp
	
	loop_vis:
			#参数j=$a0, t0=k
		addi	$a0, $a0, 1		# j=2
		slt	$t2, $s0, $a0	# if n>j,t2=1
		beq	$t2, $zero, if_vis # if j<=n, jump to if_vis
		nop
									# if not
		j		if_k
		nop
			# vis[j]=1
	if_vis:
		la		$t2, vis			# load t2=address of vis[]
		li		$t3, 0				# address=t3
		add	$t3, $t3, $a0	# t3=j
		addi	$t3, $t3, -1
		sll	$t3, $t3, 2
		add	$t3, $t3, $t2
		lw		$t2, 0($t3)			# load vis[j]=t2
		beq	$t2, 1, add_k	# if t2=1,jump to add_k
		nop	
									# if not
		addi	$a0, $a0, 1		# j++
		j		loop_vis				# go on
		nop
			# if k=n-1
	add_k:
		addi	$t0, $t0, 1		# k++		
		addi	$a0, $a0, 1		# j++
		j		loop_vis				# go on
		nop
	if_k:
		lw		$t2, 0($s0)			# t2=n
		addi	$t2, $t2, -1		# t2=n-1
		beq	$t2, $t0, print_1 # ifk=n-1, jump to print_1
		nop
									# if not
		add	$v0, $zero, $a0
		jr		$ra					# return
		nop
			# if a[j][q]!=0
	secceed:
		slt	$t6, $s0, $t4		# if n<q, =1
		beq	$t6, $zero, q_loop # if q<=n, jump to 
		nop 
									# if not
		add	$v0, $zero, $a0
		jr		$ra					# return		
		nop
	q_loop:
		la		$t3, array		# load address of array 
		lw		$t3, 0($t3)		# load t3	
		li		$t2, 0				# address=t2
			# address=(j-1)*4
		add	$t2, $t2, $a0
		addi	$t2, $t2, -1
		sll	$t2, $t2, 3
		sll	$t2, $t2, 2
		add	$t2, $t3, $t2	# t2为行数的地址
		li 	$t7, 0				# 列数地址
		add	$t7, $t7, $t4	 
		addi	$t7, $t7, -1
		sll	$t7, $t7, 2
		add	$t7, $t7, $t3
		lw		$t6, 0($t7)		# load $t6=a[i][j]
		bne	$t6, 0, if_for	# if a[i][j]!=0,jump to if_for
		nop
									# if not
		addi	$t4, $t4, 1		# q++
		j		secceed			# go on
		nop					

			# if vis[q]==0
	if_for:
			#修改寄存器变量
		la		$t3, vis			# load t3=address of vis[]
		li		$t2, 0				# address=t2
		add	$t2, $t2, $t4	# t2=q
		addi	$t2, $t2, -1
		sll	$t2, $t2, 2
		add	$t2, $t2, $t3
		lw		$t2, 0($t2)			# load vis[q]=t2
		beq	$t2, 0, loop_dfs		# if vis[q]=0,jump to dfs
		nop	
									# if not
		addi	$t4, $t4, 1		# q++
		j		secceed			# go on
		nop	
	loop_dfs:
		jal	dfs
		nop
			#vis[q]=0,修改寄存器变量
		la		$t3, vis			# load t3=address of vis[]
		li		$t2, 0				# address=t2
		add	$t2, $t2, $t4	# t2=q
		addi	$t2, $t2, -1
		sll	$t2, $t2, 2
		add	$t2, $t2, $t3
		sw		$zero, 0($t2)			# load vis[q]=t2=0
		beq	$s2, 1, print_1
		nop
		addi	$t4, $t4, 1		# q++
		j		secceed			# go on
		nop	
		
		# print 1 or 0
	print_1:
		li		$a0, 1				# 1
		li		$v0, 1
		j		end				# jump to end
		nop
	print_0:
		li 	$a0, 0				# 0
		li 	$v0, 1
		j		end				# jump to end
		nop
	end:
		li		$v0, 10			# finish the program
		syscall
