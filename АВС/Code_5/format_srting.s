.data
buffer_ans_string:	.space 256
left_angl:		.asciz "<"
right_angl:		.asciz ">"
space:			.asciz " "
tire:			.asciz " - "
double_dots:		.asciz ":"
scip_tire:		.asciz "> - <"
scip_dots:		.asciz "> : <"

# in min min, max symbols and their ascii code 
# s3 - min – reg string
# s4 - max – reg string 
# s7 - min code – reg string
# s8 - max code – reg string
# out final bufer string 
# s11 buffer adress
# <min symbol> - <ascii code> : <max symbol> - <ascii code>

.globl format_srting

.text 

format_srting:
	la s5, buffer_ans_string      # Инициализируем финальный буфер

    # Добавляем "<"
    la t3, left_angl
    mv s6, t3
    jal ra, string_sum

    # Добавляем минимальный символ
    mv s6, s3
    jal ra, string_sum

    # Добавляем "> - <"
    la s6, scip_tire
    jal ra, string_sum

    # Добавляем ASCII-код минимального символа
    mv s6, s7                     # s7 содержит строку с ASCII-кодом
    jal ra, string_sum
    
    # Добавляем "> : <"
    la s6, scip_dots
    jal ra, string_sum

    # Добавляем максимальный символ
    mv s6, s4                     # s4 содержит строку с максимальным символом
    jal ra, string_sum

    # Добавляем "> - <"
    la s6, scip_tire
    jal ra, string_sum    

    # Добавляем ASCII-код максимального символа
    mv s6, s8                     # s8 содержит строку с ASCII-кодом
    jal ra, string_sum
    
    # Добавляем ">"
    la t3, right_angl
    mv s6, t3
    jal ra, string_sum
    
    mv s11, s5

    # Завершаем строку
    ret