# Макрос для чтения целого числа
.macro input_int %reg
	li a7, 5
	ecall
	mv %reg, a0
.end_macro

# Макрос для чтения double числа
.macro input_double %reg
	li a7, 7
	ecall
	fmv.d %reg, fa0
.end_macro

# Макрос для вывода целого числа
.macro output_int %reg
	li a7, 5
	mv %reg, a0
	ecall
.end_macro

# Макрос для вывода double числа
.macro output_double %reg
	fmv.d fa0, %reg
	li a7, 3
	ecall
.end_macro

# Макрос для вывода строки
.macro print_string %str
	la a0, %str
	li a7, 4
	ecall
.end_macro

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

# Макрос для чтения свойств double
.macro read_property_double %addr, %freg
    	la t0, %addr
    	fld %freg, 0(t0)
.end_macro

# Макрос для записи свойств double
.macro write_property_double %addr, %freg
    	la t0, %addr
    	fsd %freg, 0(t0)
.end_macro

# Макрос для записи double массива
.macro input_array_doubls %addr, %size
    la t1, %addr
    mv t2, %size
    li t3, 0

input_array_doubls_loop:
    bge t3, t2, input_array_doubls_done
    print_string msg_prompt_elem

    li a7, 7
    ecall
    fsd f0, 0(t1)

    addi t1, t1, 8
    addi t3, t3, 1
    j input_array_loop

input_array_doubls_done:
.end_macro

