.include "macros.asm"

.data
prompt_n:     .asciz "Enter the number of elements 1 to 10: "
prompt_elem:  .asciz "Enter element: "
output_b:     .asciz "Array B: "
newline:      .asciz "\n"
error_msg:    .asciz "Error: invalid number of elements!\n"
max_size:     .word 10
array_a:      .space 40   # Массив A (10 элементов по 4 байта)
array_b:      .space 40   # Массив B (10 элементов по 4 байта)

.text

main:
    # Ввод количества элементов массива
    print_string prompt_n
    read_int t0
    jal input_size

    # Ввод элементов массива A
    jal input_array_a

    # Формирование массива B
    jal form_array_b

    # Вывод массива B
    print_string output_b
    jal output_array_b

    # Завершение программы
    li a7, 10
    ecall

# Подпрограмма для ввода количества элементов массива A
input_size:
    li t1, 1
    li t2, 10
    blt t0, t1, error       # Если число элементов < 1
    bgt t0, t2, error       # Если число элементов > 10
    ret

error:
    print_string error_msg  # Вывод ошибки
    j main

# Подпрограмма для ввода элементов массива A
input_array_a:
    la t1, array_a          # Указатель на начало массива A
    mv t2, t0               # Число элементов

input_loop:
    beqz t2, input_done     # Если все элементы введены

    print_string prompt_elem # Сообщение для ввода элемента
    read_int a0             # Ввод элемента
    sw a0, 0(t1)            # Сохранение элемента в массив A
    addi t1, t1, 4          # Сдвиг указателя
    addi t2, t2, -1         # Уменьшение счетчика
    j input_loop

input_done:
    ret

# Подпрограмма для формирования массива B
form_array_b:
    la t1, array_a          # Указатель на массив A
    la t2, array_b          # Указатель на массив B
    mv t3, t0               # Число элементов
    li t5, 0                # Флаг найденного положительного элемента
    li t6, 1                # Регистр, содержащий значение 1 для сравнения

form_loop:
    beqz t3, form_done      # Если все элементы обработаны

    lw t4, 0(t1)            # Загрузка элемента из массива A
    bgtz t4, copy_rest      # Если элемент положительный, переходим к копированию без изменений

    # Если положительный элемент уже найден, просто копируем элемент
    beq t5, t6, copy_elem

    # Уменьшаем элемент на 5
    addi t4, t4, -5

copy_elem:
    sw t4, 0(t2)            # Сохранение элемента в массив B
    addi t1, t1, 4          # Сдвиг указателя A
    addi t2, t2, 4          # Сдвиг указателя B
    addi t3, t3, -1         # Уменьшение счетчика
    j form_loop

copy_rest:
    li t5, 1                # Флаг найденного положительного элемента
    j copy_elem

form_done:
    ret

# Подпрограмма для вывода массива B
output_array_b:
    la t1, array_b          # Указатель на массив B
    mv t2, t0               # Число элементов

output_loop:
    beqz t2, output_done    # Если все элементы выведены

    lw a0, 0(t1)            # Загрузка элемента
    write_int a0            # Вывод элемента

    print_string newline     # Печать новой строки
    addi t1, t1, 4          # Сдвиг указателя
    addi t2, t2, -1         # Уменьшение счетчика
    j output_loop

output_done:
    ret