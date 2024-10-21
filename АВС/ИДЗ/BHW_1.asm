.include "macros.asm"
.include "data.asm"
.text
.globl main

main:
	input_size t0         			# Ввод размера массива
	input_array array_a, t0  		# Ввод массива A
	form_array array_a, array_b, t0 	# Формирование массива B
	print_string msg_output_b
	output_array array_b, t0  		# Вывод массива B
	j end

end: 
	li a7, 10
	ecall
