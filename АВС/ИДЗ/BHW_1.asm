.include "macros.asm"
.include "data.asm"
.text
.globl main

main:
	li t5, 1
	li t6, 2
	print_string msg_select_mode
	print_string msg_ur_ans
  	input_int a0
    	beq a0, t5, manual_mode
    	beq a0, t6, test_automatic
    	print_string msg_newline
    	j main

manual_mode:
    	input_size t0
    	input_array array_a, t0
   	form_array array_a, array_b, t0
    	print_string msg_output_b
    	output_array array_b, t0
    	j end

end: 
    	li a7, 10
    	ecall

test_automatic:
    	li a0, 3
    	jal test_case_0
    	li a0, 3
    	jal test_case_1
    	li a0, 5
    	jal test_case_2
    	li a0, 0
    	jal test_case_3
    	j end

# Тест 0: {1, 2, 3}
test_case_0:
    	li t0, 3
    	la t1, array_a    	    	  	# Загрузка адреса array_a
    	li t2, 1
    	sw t2, 0(t1)    	    	    	
    	li t2, 2
    	sw t2, 4(t1)    	    	    	
    	li t2, 3
    	sw t2, 8(t1)    	    	    	
    	print_string msg_output_a 		
    	output_array array_a, t0   		# Вывод массива A
    	form_array array_a, array_b, t0
    	print_string msg_output_b  		
    	output_array array_b, t0   		# Вывод массива B
    	j end_test

# Тест 1: {-1, -2, -3}
test_case_1:
    	li t0, 3
    	la t1, array_a
    	li t2, -1
    	sw t2, 0(t1)
    	li t2, -2
    	sw t2, 4(t1)
    	li t2, -3
    	sw t2, 8(t1)
    	print_string msg_output_a
    	output_array array_a, t0
    	form_array array_a, array_b, t0
    	print_string msg_output_b
    	output_array array_b, t0
    	j end_test

# Тест 2: {-2, -33, -23, 3, 22}
test_case_2:
    	li t0, 5
    	la t1, array_a
    	li t2, -2
    	sw t2, 0(t1)
    	li t2, -33
    	sw t2, 4(t1)
    	li t2, -23
    	sw t2, 8(t1)
    	li t2, 3
    	sw t2, 12(t1)
    	li t2, 22
    	sw t2, 16(t1)
    	print_string msg_output_a
    	output_array array_a, t0
    	form_array array_a, array_b, t0
    	print_string msg_output_b
    	output_array array_b, t0
    	j end_test

# Тест 3: Проверка на некорректный ввод
test_case_3:
    	print_string msg_prompt_n
    	mv t0, a0
    	output_int t0
    	print_string msg_space
    	print_string msg_error
    	j end_test

end_test:
	print_string msg_newline
    	ret
