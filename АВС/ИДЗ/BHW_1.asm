.data
msg_prompt_n:		.asciz "Enter the number of elements: "
msg_prompt_elem:	.asciz "Enter element: "
msg_output_b:		.asciz "Array B: "
msg_newline:		.asciz "\n"
msg_space:		.asciz " "
msg_error:		.asciz "Error: invalid number of elements!\n"
max_size:		.word 10
array_a:		.space 40   	# 10 elem by 4 bits
array_b:		.space 40   

.text
#.globl main

main:
    jal input_size

    jal input_array_a

    jal form_array_b

    jal output_array_b

    li a7, 10
    ecall


input_size:
    la a0, msg_prompt_n         
    li a7, 4
    ecall

    li a7, 5                
    ecall
    mv t0, a0              

    li t1, 1
    li t2, 10
    blt t0, t1, error       
    bgt t0, t2, error       
    ret

error:
    la a0, msg_error        
    li a7, 4
    ecall
    j input_size            


input_array_a:
    la t1, array_a          
    mv t2, t0               

input_loop:
    beqz t2, input_done     

    la a0, msg_prompt_elem      
    li a7, 4
    ecall

    li a7, 5               
    ecall
    sw a0, 0(t1)           
    addi t1, t1, 4         
    addi t2, t2, -1         
    j input_loop

input_done:
    ret


form_array_b:
    la t1, array_a          
    la t2, array_b          
    mv t3, t0               
    li t5, 0                
    li t6, 1                

form_loop:
    beqz t3, form_done      

    lw t4, 0(t1)            
    bgtz t4, copy_rest      

    beq t5, t6, copy_elem

    addi t4, t4, -5

copy_elem:
    sw t4, 0(t2)            
    addi t1, t1, 4         
    addi t2, t2, 4          
    addi t3, t3, -1         
    j form_loop

copy_rest:
    li t5, 1                
    j copy_elem

form_done:
    ret


output_array_b:
    la a0, msg_output_b         
    li a7, 4
    ecall

    la t1, array_b          
    mv t2, t0               

output_loop:
    beqz t2, output_done    

    lw a0, 0(t1)            
    li a7, 1
    ecall

    la a0, msg_space          
    li a7, 4
    ecall

    addi t1, t1, 4          
    addi t2, t2, -1         
    j output_loop

output_done:
    ret
