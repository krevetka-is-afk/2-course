
## !! in s5 s6 out s11 !!
.macro string_sum_wrapper_labels %label_l, %label_r
	la s5, %label_l
	la s6, %label_r
	call string_sum
.end_macro

.macro string_sum_wrapper %l, %r
	mv s5, %l
	mv s6, %r
	call string_sum
.end_macro

## !! in s5 out s11 !!
.macro char_to_ascii_code_string_wrapper %char
	mv s5, %char
	#la s5, %char			#if s5 is a char type not str label need to connent 
	call char_to_ascii_code_string
.end_macro 

## !! in s5 out s10-min s11-max !!
.macro process_min_max_wrapper %string_buffer
	la s5, %string_buffer
	call process_min_max
.end_macro 


.macro format_srting_wrapper %min_s, %max_s, %min_c, %max_c
	mv s5, %min_s
	mv s6, %max_s
	mv s7, %min_c
	mv s8, %max_c
	call format_srting
.end_macro 


.macro print_string_label %label
	la a0, %label
	li a7, 4
	ecall
.end_macro 

.macro print_string %reg
	mv a0, %reg
	li a7, 4
	ecall
.end_macro 

.macro print_char %reg
	li a7, 11
	mv a0, %reg
	ecall
.end_macro 

.macro print_int %reg
	mv a0, %reg
	li a7, 1
	ecall
.end_macro 

.macro end
	li a7, 10
	ecall
.end_macro