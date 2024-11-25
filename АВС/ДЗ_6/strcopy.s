.text
.global strcopy

# strcopy: копирует строку из %src в %dest
# Входные параметры:
# a0: адрес назначения (dest)
# a1: адрес источника (src)
# Выход:
# Строка скопирована в dest, включая '\0'

strcopy:
	add t0, a0, zero  # Указатель на dest
	add t1, a1, zero  # Указатель на src

copy_loop:
    	lb t2, 0(t1)      # Читаем символ из src
    	sb t2, 0(t0)      # Пишем символ в dest
    	beqz t2, end      # Если символ == '\0', завершить
    	addi t0, t0, 1    # Увеличиваем указатель dest
    	addi t1, t1, 1    # Увеличиваем указатель src
    	j copy_loop

end:
    	ret