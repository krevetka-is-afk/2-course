.include "macros_lib.s"
.data
left: 		.asciz "Helo "
right:		.asciz "World\n"
char:		.asciz "H"
buffer:		.asciz "Holloworld"
msg_new_line:	.asciz "\n"

.global main
.text

main:
	
	process_min_max_wrapper buffer
	
	print_string s10
	mv a4, s10 	#min char
	
	print_string_label msg_new_line
	
	print_string s11
	mv a5, s11 	#max char
	
	print_string_label msg_new_line
	
	process_min_max_wrapper buffer
	char_to_ascii_code_string_wrapper s10
	mv a1, s11
	print_string s11
	
	
	print_string_label msg_new_line
	
	process_min_max_wrapper buffer
	char_to_ascii_code_string_wrapper s11
	print_string s11
	mv t6, s11
	
	print_string_label msg_new_line
	
	print_string a4
	print_string a5
	print_string a1
	print_string t6
	print_string_label msg_new_line
	
	string_sum_wrapper a4, a1
	print_string s5
	print_string_label msg_new_line
	
	string_sum_wrapper a5, t6
	print_string s5
	print_string_label msg_new_line
	
	#format_srting_wrapper a4, a5, a1, t6
	#print_string s11
	
	end