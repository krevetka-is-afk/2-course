.data
msg_prompt_n:    .asciz "Enter the number of elements: "
msg_prompt_elem: .asciz "Enter element: "
msg_output_b:    .asciz "Array B: "
msg_newline:     .asciz "\n"
msg_space:       .asciz " "
msg_error:       .asciz "Error: invalid number of elements!\n"
max_size:        .word 10
array_a:         .space 40  # 10 элементов по 4 байта (целое число)
array_b:         .space 40
