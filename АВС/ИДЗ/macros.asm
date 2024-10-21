# Макрос для чтения целого числа
.macro input_int %reg
    li a7, 5
    ecall
    mv %reg, a0
.end_macro

# Макрос для вывода строки
.macro print_string %str
    la a0, %str
    li a7, 4
    ecall
.end_macro

# Макрос для ввода размера массива с проверкой
.macro input_size %size_reg
input_again:
    print_string msg_prompt_n
    input_int %size_reg
    li t1, 1
    li t2, 10
    blt %size_reg, t1, size_error
    bgt %size_reg, t2, size_error
    j input_size_done

size_error:
    print_string msg_error
    j input_again
 
input_size_done:
.end_macro

# Макрос для ввода массива
.macro input_array %addr, %size
    la t1, %addr
    mv t2, %size
    li t3, 0

input_array_loop:
    bge t3, t2, input_array_done
    print_string msg_prompt_elem
    li a7, 5
    ecall
    sw a0, 0(t1)
    addi t1, t1, 4
    addi t3, t3, 1
    j input_array_loop

input_array_done:
.end_macro

# Макрос для формирования массива B на основе массива A
.macro form_array %src_addr, %dest_addr, %size
    la t1, %src_addr
    la t2, %dest_addr
    mv t3, %size
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
.end_macro

# Макрос для вывода массива
.macro output_array %addr, %size
    la t1, %addr
    mv t2, %size
    li t3, 0

output_array_loop:
    bge t3, t2, output_array_done
    lw a0, 0(t1)
    li a7, 1
    ecall
    print_string msg_space
    addi t1, t1, 4
    addi t3, t3, 1
    j output_array_loop

output_array_done:
    print_string msg_newline
.end_macro
