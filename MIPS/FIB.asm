.data
  fibs: .space   200   #在数据段中保留下一个指定字节数，相当于开一个数组用来存储数   
  size: .word  12     #将列出的值存储为Word边界上的32位字，相当于设置数组下标最大值
  space:.asciiz  " "          
  head: .asciiz  "The Fibonacci numbers are:\n"
  .text		#7-13对应初始化工作，并为寄存器分配功能
        la   $t0, fibs      # load address of array  
        la   $t5, size      # load address of size variable  
        lw   $t5, 0($t5)    # load array size 
        li   $t2, 1         # 1 is first and second Fib. number 
        sw   $t2, 0($t0)    # F[0] = 1 
        sw   $t2, 4($t0)    # F[1] = F[0] = 1  
        addi $t1, $t5, -2   # Counter for loop, will execute (size-2) times  
  loop: lw   $t3, 0($t0)      
        lw   $t4, 4($t0)      
        add  $t2, $t3, $t4   
        sw   $t2, 8($t0)      
        addi $t0, $t0, 4    #指针往下一个数移  
        addi $t1, $t1, -1   #循环次数减少 
        bgtz $t1, loop      #当寄存器中的值大于0时跳转到标签所在的位置   
        la   $a0, fibs      #返回标签地址 
        add  $a1, $zero, $t5 #返回栈里数字大小
        jal  print          #跳转并将下一行的地址保存在$ra寄存器中 
        li   $v0, 10        #退出 
        syscall               
  print:add  $t0, $zero, $a0  
        add  $t1, $zero, $a1 
        la   $a0, head       
        li   $v0, 4         #打印字符串 
        syscall              
  out:  lw   $a0, 0($t0)     
        li   $v0, 1         #打印整型
        syscall              
        la   $a0, space     #打印空格  
        li   $v0, 4           
        syscall              
        addi $t0, $t0, 4     
        addi $t1, $t1, -1    
        bgtz $t1, out        
        jr   $ra            #跳转至保存的$ra寄存器地址处
