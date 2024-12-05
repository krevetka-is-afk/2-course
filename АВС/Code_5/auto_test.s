.include "macros_lib.s"
.eqv    TEXT_SIZE 512								
.data
	input_file_name1:	.asciz "tests/input_text/test1.txt"		 
	input_file_name2:	.asciz "tests/input_text/test2.txt"		 
	input_file_name3:	.asciz "tests/input_text/test3.txt"  
	input_file_name4:	.asciz "tests/input_text/test4.txt"		 
	input_file_name5:	.asciz "tests/input_text/test5.txt"		 
	input_file_name6:	.asciz "tests/input_text/test6.txt"
	
	output_file_name1:	.asciz "tests/output_text/test1.txt"
	output_file_name2:	.asciz "tests/output_text/test2.txt"
	output_file_name3:	.asciz "tests/output_text/test3.txt"
	output_file_name4:	.asciz "tests/output_text/test4.txt"
	output_file_name5:	.asciz "tests/output_text/test5.txt"
	output_file_name6:	.asciz "tests/output_text/test6.txt"
	
	answer1:	.space 256
	answer2:	.space 256
	answer3:	.space 256
	answer4:	.space 256
	answer5:	.space 256
	answer6:	.space 256

#.globl main
.text
#main:
	run_test_case(input_file_name1, output_file_name1, answer1)
	run_test_case(input_file_name2, output_file_name2, answer2)
	run_test_case(input_file_name3, output_file_name3, answer3)
	run_test_case(input_file_name4, output_file_name4, answer4)
	run_test_case(input_file_name5, output_file_name5, answer5)
	run_test_case(input_file_name6, output_file_name6, answer6)
	
	end
