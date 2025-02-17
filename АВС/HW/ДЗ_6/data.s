.data
msg_src: 	.asciz "Enter source string: "
msg_res: 	.asciz "Copied string: "
msg_newline: 	.asciz "\n"
buffer_src: 	.space 128  	# Буфер для ввода строки
buffer_dest:	.space 128  	# Буфер для хранения результата

test1_src: 	.asciz "Hello, RISC-V!"
test2_src: 	.asciz "Assembly programming"
test3_src: 	.asciz "1234567890"
