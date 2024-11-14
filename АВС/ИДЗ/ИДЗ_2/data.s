.data

msg_newline:      		.asciz "\n"
msg_space:        		.asciz " "
msg_error:        		.asciz "Error: invalid number of elements!\n"
msg_select_mode:  		.asciz "Select mode:\n1. Manual input\n2. Automatic test\n"
msg_ur_ans:       		.asciz "_: "

msg_prompt_input_double: 	.asciz "input_double x = "
msg_select_mode_accuracy: 	.asciz "Select mode accuracy:\n1. |term| <= tolerance * sum\n2. |sum - prev_sum| ≤ tolerance\n"
msg_prompt_accuracy_change: 	.asciz "Do you want to change accuracy?\nDefault value 0,0005\nRecomend set more mb 0.02\n"
msg_select_mode_to_change_accuracy: .asciz "1. No (keep 0.0005)\n2. Yes, please\n"

msg_your_accuracy: 		.asciz "your_accuracy = "
msg_accuracy_set:  		.asciz "Complite!\nNow accuracy is "
msg_method_1:      		.asciz "Method_1\n"
msg_method_2:      		.asciz "Method_2\n"

# Свойства и константы
x:           			.double 1.0         		# Значение x
tolerance:   			.double 0.0005      		# Точность
one:         			.double 1.0         		# Константа 1.0
minus_one:   			.double -1.0        		# Константа -1.0
answer:      			.double 0.0         		# Для хранения результата
method:      			.word 1             		# Выбор метода (1 или 2)
previous_sum:			.double 0.0         		# Предыдущая сумма для второго метода

# Тестовые данные
test_x_values:      		.double -5.0, 0.0, 1.0, 2.5, 3.7 # Набор значений x для тестов
test_tolerances:    		.double 0.0005, 0.001, 0.01      # Набор точностей для тестов
test_methods:       		.word 1, 2, 1                    # Набор методов для тестов

msg_test_start:     		.asciz "Starting test...\n"
msg_test_case:      		.asciz "Test case: x = "
msg_tolerance_case: 		.asciz " Tolerance = "
msg_method_case:    		.asciz " Method = "
msg_result:         		.asciz " Result = "
