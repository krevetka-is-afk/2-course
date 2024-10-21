# Макрос для чтения целого числа
.macro input_int %reg
    li a7, 5           
    ecall
    mv %reg, a0        
.end_macro

# Макрос для вывода целого числа
.macro output_int %reg
    mv a0, %reg        
    li a7, 1          
    ecall
.end_macro

# Макрос для вывода строки
.macro print_string %str
    la a0, %str        
    li a7, 4           
    ecall
.end_macro
