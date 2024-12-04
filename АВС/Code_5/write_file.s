.include "macros_lib.s"
.global write_file
.text
write_file:
# В a0 лежит имя открываемого файла
# В a1 лежит адрес текста для записи
# В a2 лежит размер текста для записи
	push(ra)
	push(s3)
	push(s4)
	push(s5)
	push(s6)
	mv	s3, a0
	mv	s4, a1
	mv	s5, a2

	open(file_name, WRITE_ONLY)
    	mv   	s6, a0       	# save the file descriptor
    	write(s6, s4, s5)

	close(s6)
	
	pop(s6)
	pop(s5)
	pop(s4)
	pop(s3)
	pop(ra)
	ret