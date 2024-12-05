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
# a0 Ц buffer adres
# a1 Ц size of text portion

 	mv s6, a0 #Ц buffer adres
 	mv s5, a1 #Ц size of text portion

 	open(s6, READ_ONLY)
 	mv s0, a0 #- descriptor

 allocate(s5)
 	mv s2, a0  #- heap adres
 	mv s3, a0 #- curr heap adres
 	mv s4, s5 #- size of text portion to control out rule
 	mv s7, zero #- len of already readed text neds to add 0 at the end

 	li s1, -1
 	li s10, 1
 	li s11, 20

read_loop:
 	bgt s10, s11, end_read_loop #er_size
 	# „тение информации из файла
 	read_addr_reg(s0, s3, s5)
 	beq a0, s1, end_read_loop #er_read  # ќшибка чтени€
 	mv    s8, a0         # ƒлина текста в текущей порции
 	add  s7, s7, s8  # ќбновление общей длины
 	bne s8, s4, end_read_loop
 	allocate(s5)
 	add s3, s3, s4  # —двиг адреса дл€ чтени€
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
