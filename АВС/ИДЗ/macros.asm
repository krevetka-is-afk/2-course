# Макрос для чтения целого числа
.macro read_int %reg
    li a7, 5           # Системный вызов для чтения числа
    ecall
    mv %reg, a0        # Сохранение числа в указанный регистр
.end_macro

# Макрос для вывода целого числа
.macro write_int %reg
    mv a0, %reg        # Загружаем число для вывода
    li a7, 1           # Системный вызов для вывода числа
    ecall
.end_macro

# Макрос для вывода строки
.macro print_string %str
    la a0, %str        # Загрузка строки
    li a7, 4           # Системный вызов для вывода строки
    ecall
.end_macro

.macro input_int %reg
	li a7, 5
	ecall
	mv %reg, a0
.end_macro