.include "macros.asm"

.data
test_1:    .word -100, -50, -20, 5, 10    # Тестовый массив
test_2:    .word -7, 15, 0, 5            # Другой тестовый массив
output_b:  .asciz "Test B: "
newline:   .asciz "\n"
max_size:  .word 10
array_b:   .space 40

.text
.globl main_test

main_test:
    # Загружаем первый тест
    la t1, test_1
    li t0, 5               # Установить размер массива
    la t2, array_b         # Указатель на массив B
    jal form_array_b        # Выполняем обработку

    # Выводим результат для первого теста
    print_string output_b
    jal output_array_b

    print_string newline    # Разделитель

    # Загружаем второй тест
    la t1, test_2
    li t0, 4               # Установить размер массива
    la t2, array_b         # Указатель на массив B
    jal form_array_b        # Выполняем обработку

    # Выводим результат для второго теста
    print_string output_b
    jal output_array_b

    # Завершение программы
    li a7, 10
    ecall