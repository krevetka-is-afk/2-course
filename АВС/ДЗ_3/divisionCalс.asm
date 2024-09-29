.data
prompt_dividend:  .asciz "Enter dividend: "
prompt_divisor:   .asciz "Enter divisor: "
error_msg:        .asciz "Error: Division by zero!\n"
result_msg:       .asciz "Quotient: "
remainder_msg:    .asciz ", Remainder: "

.text
main:
    la   a0, prompt_dividend  # Выводим запрос на делимое
    li   a7, 4                   
    ecall

    li   a7, 5                 
    ecall
    mv t0, a0                 # Сохранение делимого 

    la   a0, prompt_divisor
    li   a7, 4                # Выводим запрос на делитель
    ecall

    li   a7, 5                
    ecall
    mv t1, a0                 # Сохранение делителя

    
    beq  t1, zero, div_by_zero  # Проверка на деление на ноль

    # Обработка знаков
    li   t2, 1                  
    blt  t0, zero, neg_dividend # переходим на лейбл, если меньше 0
    blt  t1, zero, neg_divisor  # переходим на лейбл, если меньше 0
    j    compute_division

neg_dividend:
    neg  t0, t0                 # Делаем делимое положительным
    li   t2, -1                 # Меняем знак частного
    j    check_divisor

neg_divisor:
    neg  t1, t1                 # Делаем делитель положительным
    li   t2, -1                 # Меняем знак частного

check_divisor:
    blt  t1, zero, neg_divisor

compute_division:
    mv t3, zero               # Счетчик для частного 
    mv t4, t0                 # Изменение делимого
division_loop:
    blt  t4, t1, sign  # Если остаток < делителя, выходим
    sub  t4, t4, t1             # Вычитаем делитель из остатка
    addi t3, t3, 1              # Увеличиваем результат на 1
    j    division_loop

sign:
    mul  t3, t3, t2             # Применяем знак к частному

    la   a0, result_msg
    li   a7, 4
    ecall

    li   a7, 1                  # Вывод частного
    mv a0, t3
    ecall

    la   a0, remainder_msg
    li   a7, 4
    ecall

    li   a7, 1                  # Вывод остатка
    mv a0, t4
    ecall

    j    end_program

div_by_zero:
    la   a0, error_msg
    li   a7, 4                  # Печать ошибки
    ecall

end_program:
    li   a7, 10                 # Завершение программы
    ecall
