.include "macros_lib.s"

.eqv	NAME_SIZE 256	# Размер буфера для имени файла
.eqv    TEXT_SIZE 512	# Размер буфера для текста

.data
er_name_mes:    .asciz "Incorrect file name\n"
er_read_mes:    .asciz "Incorrect read operation\n"

left:       	.asciz "Helo "
right:      	.asciz "World\n"
char:       	.asciz "H"
buffer:     	.asciz "Holloworld"
msg_new_line:   .asciz "\n"

buffer_result:      	.space 256   	# Буфер для объединённых строк
buffer_min_char_code: 	.space 12  	# Буфер для ASCII-кода минимального символа
buffer_max_char_code: 	.space 12  	# Буфер для ASCII-кода максимального символа

.globl file_name
file_name:      .space	NAME_SIZE	# Имя читаемого файла
strbuf:	        .space TEXT_SIZE	# Буфер для читаемого текста
result_buf:     .space TEXT_SIZE        # Буфер для результата
result_len:     .word  0                # Длина строки результата

.globl main
.text
###############################################################
main:
	# Ввод имени файла для чтения
    	print_str ("Input path to file for reading: ")
    	str_get(file_name, NAME_SIZE)
    	open(file_name, READ_ONLY)
    	li	s1, -1			# Проверка на корректное открытие
    	beq	a0, s1, er_name		# Ошибка открытия файла
   	mv   	s0, a0       		# Сохранение дескриптора файла
###############################################################
    	# Выделение памяти в куче для буфера
    	allocate(TEXT_SIZE)			# Результат хранится в a0
    	mv 	s3, a0			# Адрес кучи
    	mv 	s5, a0			# Изменяемый адрес кучи
    	li	s4, TEXT_SIZE		# Размер блока памяти
    	mv	s6, zero		# Длина прочитанного текста
###############################################################
read_loop:
    	# Чтение информации из файла
    	read_addr_reg(s0, s5, TEXT_SIZE)
    	beq	a0, s1, er_read		# Ошибка чтения
    	mv   	s2, a0       		# Длина текста в текущей порции
    	add 	s6, s6, s2		# Обновление общей длины
    	bne	s2, s4, end_loop
    	allocate(TEXT_SIZE)
    	add	s5, s5, s2		# Сдвиг адреса для чтения
    	b read_loop
end_loop:
    	# Закрытие файла
    	close(s0)
###############################################################
	# Установка нуля в конце строки
    	mv	t0, s3
    	add 	t0, t0, s6
    	addi 	t0, t0, 1
    	sb	zero, (t0)
###############################################################
    	# Вызов обработки минимального и максимального символов
    	mv 	a0, s3          # Адрес буфера
    	# Находим минимальный и максимальный символ
    	process_min_max_wrapper a0
    	print_string s10
    	print_string s11
    	print_string_label msg_new_line
    	string_sum_wrapper s10, s11
    	print_string s11
    	write_property_word result_len, s11
    	
###############################################################
    	# Вывод результата на консоль
    	print_str ("Processed text:\n")
    	print_str_label result_len

###############################################################
    	print_str ("Writing result to file...\n")
    	# Ввод имени файла для записи
    	print_str ("Input path to file for writing: ")
    	str_get(file_name, NAME_SIZE)
    	write_file_wrapper(file_name, result_len, NAME_SIZE)

###############################################################
    	# Завершение программы
    	end
###############################################################
er_name:
    	# Сообщение об ошибке имени файла
    	print_str_label er_name_mes
    	end
er_read:
    	# Сообщение об ошибке чтения
    	print_str_label er_read_mes
    	end








    	# Сохраняем адреса минимального и максимального символов
    	mv t0, s10    # t0 = адрес буфера минимального символа
    	mv t1, s11    # t1 = адрес буфера максимального символа

    	# Загружаем коды минимального и максимального символов
    	lb t2, 0(t0)  # t2 = код минимального символа
    	lb t3, 0(t1)  # t3 = код максимального символа

    	# Печатаем минимальный символ
    	print_string t0
    	print_string_label msg_new_line

    	# Печатаем максимальный символ
    	print_string t1
    	print_string_label msg_new_line

    # Преобразуем минимальный символ в ASCII-код
	mv s5, t2           # s5 = код минимального символа
    	la s6, buffer_min_char_code   # s6 = адрес выходного буфера
    	call char_to_ascii_code_string

    	# Печатаем ASCII-код минимального символа
    	la a0, buffer_min_char_code
    	li a7, 4
    	ecall
    	print_string_label msg_new_line

    # Преобразуем максимальный символ в ASCII-код
    mv s5, t3           # s5 = код максимального символа
    la s6, buffer_max_char_code   # s6 = адрес выходного буфера
    call char_to_ascii_code_string

    # Печатаем ASCII-код максимального символа
    la a0, buffer_max_char_code
    li a7, 4
    ecall
    print_string_label msg_new_line

    # Печатаем минимальный и максимальный символы, их ASCII-коды
    print_string t0         # Минимальный символ
    print_string t1         # Максимальный символ
    la a0, buffer_min_char_code
    li a7, 4
    ecall                   # Печатаем ASCII-код минимального символа
    la a0, buffer_max_char_code
    li a7, 4
    ecall                   # Печатаем ASCII-код максимального символа
    print_string_label msg_new_line

    # Объединяем минимальный символ и его ASCII-код
    mv s5, t0                 # s5 = адрес минимального символа
    la s6, buffer_min_char_code    # s6 = адрес строки ASCII-кода минимального символа
    call string_sum

    # Печатаем результат объединения
    print_string s5
    print_string_label msg_new_line

    # Объединяем максимальный символ и его ASCII-код
    mv s5, t1                 # s5 = адрес максимального символа
    la s6, buffer_max_char_code    # s6 = адрес строки ASCII-кода максимального символа
    call string_sum

    # Печатаем результат объединения
    print_string s5
    print_string_label msg_new_line

    # Завершаем программу
    end
