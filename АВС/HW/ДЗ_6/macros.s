.macro strcpy %dest, %src
    	mv a0, %dest  # Передаем адрес назначения
   	mv a1, %src   # Передаем адрес источника
    	jal strcopy   # Вызываем подпрограмму
.end_macro

# Макрос для вывода строки
.macro print_string %str
	la a0, %str
	li a7, 4
	ecall
.end_macro

# Макрос для чтения строки
.macro read_string() 
	li a7, 8
	ecall
.end_macro