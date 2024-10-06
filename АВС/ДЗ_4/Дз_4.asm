.data
msg_start:	.asciz "Enter the number of elements 1 to 10: "
msg_elem_in:	.asciz "Enter element: "
msg_new_line:	.asciz "\n"
msg_sum:	.asciz "Sum = "
msg_arroverflow .asciz "Array overflow! Last sum = "

max_elements: 	.word 10
array:		.space 40

.text
main:
la	a0, msg_start
li 	a7, 4
ecall
