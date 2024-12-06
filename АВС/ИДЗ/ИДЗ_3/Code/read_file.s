.include "macros_lib.s"

.globl read_file
.text
read_file:
	 push(ra)
	 push(s0)
	 push(s1)
	 push(s2)
	 push(s3)
	 push(s4)
	 push(s5)
	 push(s6)
	 push(s7)
	 push(s8)
	 push(s9)
# В a0 лежит адрес буфера
# В a1 лежит размер текстовой части

 	mv s6, a0 # В s6 помещаем адрес буфера
 	mv s5, a1 # В s5 помещаем размер текстовой части

 	open(s6, READ_ONLY)
 	mv s0, a0 # В s0 помещаем дескриптор

 allocate(s5)
 	mv s2, a0  # В s2 помещаем адрес кучи
 	mv s3, a0  # В s3 помещаем текущий адрес кучи
 	mv s4, s5  # В s4 помещаем размер текстовой части для контроля выхода за пределы
 	mv s7, zero # В s7 помещаем длину уже прочитанного текста, чтобы добавить 0 в конце

 	li s1, -1
 	li s10, 1
 	li s11, 20

read_loop:
 	bgt s10, s11, end_read_loop # Проверяем превышение размера
 	# Читаем данные из файла
 	read_addr_reg(s0, s3, s5)
 	beq a0, s1, end_read_loop # Если ошибка чтения
 	mv    s8, a0         # Переносим размер прочитанного текста
 	add  s7, s7, s8      # Увеличиваем длину прочитанного текста
 	bne s8, s4, end_read_loop
 	allocate(s5)
 	add s3, s3, s4       # Перемещаем указатель для записи
 	addi s10, s10, 1
	b read_loop

end_read_loop:
 	close(s0)
	write_ending_zero(s2, s7)
 	mv a0, s2

	pop(s9)
	pop(s8)
 	pop(s7)
 	pop(s6)
 	pop(s5)
	pop(s4)
	pop(s3)
	pop(s2)
	pop(s1)
	pop(s0)
	pop(ra)
 	ret
