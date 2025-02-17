.include "macros_lib.s"
.globl process_min_max
.text
process_min_max:
    # Входные параметры:
    # a0 - адрес начала строки
    # Выходные параметры:
    # a0 - код минимального символа
    # a1 - код максимального символа
    push(ra)
    mv t5, a0              # Сохраняем адрес начала строки
    li t1, 255             # максимальное значение для ASCII
    li t2, 0               # минимальное значение для ASCII

find_loop:
    lb t0, 0(t5)           # Считываем текущий символ строки
    beqz t0, end_p_m_m     # Если символ равен 0 (конец строки), завершаем цикл

    # Проверка символа на допустимость
    li t3, 32              # Минимальный допустимый символ пробел
    blt t0, t3, find_next  

    blt t0, t1, update_min # обновляем минимум
    bgt t0, t2, update_max # обновляем максимум
    j find_next            
    
update_min:
    mv t1, t0              
    j find_next

update_max:
    mv t2, t0              
    j find_next

find_next:
    addi t5, t5, 1         
    j find_loop           

end_p_m_m:
    mv a0, t1    
    mv a1, t2
    pop(ra)
    ret                    
