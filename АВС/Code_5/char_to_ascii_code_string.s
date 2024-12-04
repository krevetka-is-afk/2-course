.data
# Буферы теперь передаются из main

.text
.globl char_to_ascii_code_string
char_to_ascii_code_string:
    # s5: целое число (код символа)
    # s6: адрес выходного буфера

    li a2, 0              # a2 = счетчик (количество цифр)
    mv t5, s6             # Сохраняем начальный адрес буфера

convert_loop:
    # Проверяем, не равно ли число нулю
    beq s5, zero, zero_case    # Если s5 == 0, обрабатываем отдельно

    li t0, 10
convert_digit:
    rem t1, s5, t0        # t1 = s5 % 10
    addi t1, t1, '0'      # Преобразуем в ASCII
    sb t1, 0(s6)          # Сохраняем символ в буфер
    addi s6, s6, 1        # Увеличиваем указатель буфера
    addi a2, a2, 1        # Увеличиваем счетчик цифр
    div s5, s5, t0        # s5 = s5 / 10
    bnez s5, convert_digit
    j reverse_digits

zero_case:
    li t1, '0'
    sb t1, 0(s6)
    addi s6, s6, 1
    addi a2, a2, 1
    j reverse_digits

reverse_digits:
    sb zero, 0(s6)        # Добавляем нуль-терминатор
    addi s6, s6, -1       # Отступаем на один символ
    mv t0, t5             # t0 = начало буфера
    mv t1, s6             # t1 = конец числа

reverse_loop:
    blt t0, t1, reverse_continue
    j reverse_done

reverse_continue:
    lb t2, 0(t0)
    lb t3, 0(t1)
    sb t3, 0(t0)
    sb t2, 0(t1)
    addi t0, t0, 1
    addi t1, t1, -1
    j reverse_loop

reverse_done:
    ret
