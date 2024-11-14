.include	"macros.s"
.include	"data.s"

.text

main:
# Инициализация переменных
	read_property_double x, f0
    #la  a0, x
    #fld f0, 0(a0)           # Загружаем x в f0
    	read_property_double one, f1
    #la  a1, one
    #fld f1, 0(a1)           # f1 = 1.0 (первый член ряда и начальная сумма)

    #la  a2, answer
    	fmv.d f2, f1            # Копируем первый член в сумму

    	fmv.d f3, f1            # f3 = 1.0 (начальный член ряда)
    	li  a3, 1               # Счетчик n 
    	read_property_double tolerance, f4
    #la  a4, tolerance
    #fld f4, 0(a4)           # Загружаем tolerance в f4

# Выбор режима
    	li t5, 1
	li t6, 2
	print_string msg_select_mode
	print_string msg_ur_ans
  	input_int a0
    	beq a0, t5, manual_mode
    	beq a0, t6, test_mode
    	print_string msg_newline
    	j main
    
manual_mode:
	# input double x
	print_string msg_prompt_input_double
	input_double fa0
	fmv.d 	f0, fa0
	print_string msg_newline
	
	# chose accuracy value
	print_string msg_prompt_accuracy_change
	print_string msg_select_mode_to_change_accuracy
   change_ur_mind:					# wrong ans loop
	print_string msg_ur_ans
	input_int a0
	beq a0, t5, chose_accuracy_method
    	beq a0, t6, change_accuracy_value
    	print_string msg_newline
    	j change_ur_mind
    	
    change_accuracy_value:				# wrong ans loop
    	print_string msg_your_accuracy
	input_double fa0
	fmv.d 	f4, fa0
	print_string msg_accuracy_set
	output_double f4
	print_string msg_newline
	print_string msg_newline
	j chose_accuracy_method
	
	# chose accuracy method
chose_accuracy_method:
	print_string msg_select_mode_accuracy
	print_string msg_ur_ans
  	input_int a0
  	write_property_word method, a0
    	beq a0, t5, check_method_1
    	beq a0, t6, check_method_2
    	print_string msg_newline
    	j chose_accuracy_method

   
test_mode:

while_loop:
    # Выбор метода
    	read_property_word method, a5

    # Метод 1: |term| <= tolerance * sum
    	li  a6, 1
    	beq a5, a6, check_method_1

    # Метод 2: |sum - previous_sum| <= tolerance
    	li  a6, 2
    	beq a5, a6, check_method_2

check_method_1:
    # Проверка условия окончания для метода 1
    	fmul.d f5, f4, f2       # f5 = tolerance * sum
    	fabs.d f6, f3           # f6 = |term|
    	fle.d a6, f6, f5        # Проверка |term| <= tolerance * sum
    	bnez a6, end_loop       # Если условие выполнено, выходим из цикла
	j   update_series

check_method_2:
    # Проверка условия окончания для метода 2
    	read_property_double previous_sum, f9           # Загружаем previous_sum в f9
    	fsub.d f10, f2, f9      # f10 = |sum - previous_sum|
    	fabs.d f10, f10         # Берем абсолютное значение
    	fle.d a6, f10, f4       # Проверка |sum - previous_sum| <= tolerance
    	bnez a6, end_loop       # Если условие выполнено, выходим из цикла

    # Обновление previous_sum для следующей итерации
    	write_property_double previous_sum, f2
    #fsd f2, 0(a7)           # Сохраняем текущее значение sum в previous_sum

update_series:
    # Вычисление следующего члена ряда: term *= -x / n
    	read_property_double minus_one, f7
    #la  a1, minus_one
    #fld f7, 0(a1)           # f7 = -1.0
    	fmul.d f3, f3, f7       # term = term * -1
    	fmul.d f3, f3, f0       # term = term * x
    	fcvt.d.w f8, a3         # Преобразуем n (целое) в float
    	fdiv.d f3, f3, f8       # term = term / n

    # Обновление суммы
    	fadd.d f2, f2, f3       # sum += term
    	addi a3, a3, 1          # Увеличиваем n

    # Переход к следующей итерации
    	j while_loop

end_loop:
    # Сохранение результата
    	write_property_double answer, f2
    #la  a2, answer
    #fsd f2, 0(a2)

output_ans:
    # Вывод результата
    	read_property_double answer, fa0
    #fmv.d fa0, f2           # Перемещаем результат в fa0
    	output_double fa0
    	#li a7, 3                # Системный вызов для вывода double
    	#ecall
    	j end

end:
    	li a7, 10               # Завершение программы
    	ecall
