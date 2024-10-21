.data
msg_prompt_n:    	.asciz "Enter the number of elements: "
msg_prompt_elem: 	.asciz "Enter element: "
msg_output_a:		.asciz "Array A: "
msg_output_b:    	.asciz "Array B: "
msg_newline:     	.asciz "\n"
msg_space:       	.asciz " "
msg_error:       	.asciz "Error: invalid number of elements!\n"
msg_select_mode:	.asciz "Select mode:\n1. Manual input\n2. Automatic test\n"
msg_ur_ans:       	.asciz "_: "

max_size:        	.word 10
array_a:         	.space 40  # 10 элементов по 4 байта (целое число)
array_b:         	.space 40
