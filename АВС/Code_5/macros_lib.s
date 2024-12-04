# Макрос для чтения свойств 
.macro read_property_word %addr, %reg
    la t0, %addr
    lw %reg, 0(t0)
.end_macro

# Макрос для записи свойств
.macro write_property_word %addr, %reg
    la t0, %addr
    sw %reg, 0(t0)
.end_macro

## !! in s5 s6 out s11 !!
.macro string_sum_wrapper_labels %label_l, %label_r
	la 	s5, %label_l
	la 	s6, %label_r
	call string_sum
.end_macro

.macro string_sum_wrapper %l, %r
	mv 	s5, %l
	mv 	s6, %r
	call string_sum
.end_macro

## !! in s5 out s11 !!
.macro char_to_ascii_code_string_wrapper %char
	mv 	s5, %char
	#la 	s5, %char			#if s5 is a char type not str label need to connent 
	call char_to_ascii_code_string
.end_macro 

## !! in s5 out s10-min s11-max !!
.macro process_min_max_wrapper %string_buffer
	#la 	s5, %string_buffer
	mv	s5, %string_buffer
	call process_min_max
.end_macro 


.macro format_srting_wrapper %min_s, %max_s, %min_c, %max_c
	mv 	s5, %min_s
	mv 	s6, %max_s
	mv 	s7, %min_c
	mv 	s8, %max_c
	call format_srting
.end_macro 


.macro print_string_label %label
	la 	a0, %label
	li 	a7, 4
	ecall
.end_macro 

.macro print_string %reg
	mv 	a0, %reg
	li 	a7, 4
	ecall
.end_macro 

# Печать строковой константы, ограниченной нулевым символом
.macro print_str(%x)
   	.data
str:
   	.asciz %x
   	.text
   	push (a0)
   	li a7, 4
   	la a0, str
   	ecall
   	pop (a0)
.end_macro

.macro print_str_label %label
   la a0, %label
   li a7, 4
   ecall
.end_macro

.macro print_char %reg
	li 	a7, 11
	mv 	a0, %reg
	ecall
.end_macro 

.macro print_int %reg
	mv 	a0, %reg
	li 	a7, 1
	ecall
.end_macro 

# Ввод строки в буфер заданного размера с заменой перевода строки нулем
# %strbuf - адрес буфера
# %size - целая константа, ограничивающая размер вводимой строки
.macro str_get(%strbuf, %size)
    	la      a0, %strbuf
    	li      a1, %size
    	li      a7, 8
    	ecall
    	push(s0)
    	push(s1)
    	push(s2)
    	li	s0, '\n'
    	la	s1, %strbuf
next:
    	lb	s2, (s1)
    	beq 	s0, s2, replace
    	addi 	s1, s1, 1
    	b	next
replace:
    	sb	zero, (s1)
    	pop(s2)
    	pop(s1)
    	pop(s0)
.end_macro

# Чтение информации из открытого файла,
# когда адрес буфера в регистре
.macro read_addr_reg(%file_descriptor, %reg, %size)
    	li   	a7, 63       	# Системный вызов для чтения из файла
   	mv   	a0, %file_descriptor       # Дескриптор файла
    	mv   	a1, %reg   	# Адрес буфера для читаемого текста из регистра
    	li   	a2, %size 		# Размер читаемой порции
    	ecall             	# Чтение
.end_macro

.macro write(%file_descriptor, %strbuf, %size)
   	li   	a7, 64       			# system call for write to file
   	mv   	a0, %file_descriptor       	# file descriptor
    	mv   	a1, %strbuf  			# address of buffer from which to write
    	mv   	a2, %size       		# hardcoded buffer length
    	ecall             			# write to file
.end_macro

.macro write_file_wrapper(%file_name, %answer, %size)
	la 	a0, %file_name
	la 	a1, %answer
	li 	a2, %size
	jal write_file
.end_macro

# Закрытие файла
.macro close(%file_descriptor)
    	li   	a7, 57       # Системный вызов закрытия файла
    	mv   	a0, %file_descriptor  # Дескриптор файла
    	ecall             # Закрытие файла
.end_macro

# Выделение области динамической памяти заданного размера
.macro allocate(%size)
    	li 	a7, 9
    	li 	a0, %size	# Размер блока памяти
    	ecall
.end_macro

# Открытие файла для чтения, записи, дополнения
.eqv READ_ONLY	0	# Открыть для чтения
.eqv WRITE_ONLY	1	# Открыть для записи
.eqv APPEND	9	# Открыть для добавления
.macro open(%file_name, %opt)
    	li   	a7 1024     	# Системный вызов открытия файла
    	la      a0 %file_name   # Имя открываемого файла
    	li   	a1 %opt        	# Открыть для чтения (флаг = 0)
    ecall             		# Дескриптор файла в a0 или -1)
.end_macro

# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

.macro end
	li 	a7, 10
	ecall
.end_macro