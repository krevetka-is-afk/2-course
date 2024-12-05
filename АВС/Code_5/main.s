.include "macros_lib.s"

.eqv  	NAME_SIZE 256  # Размер буфера для имени файла
.eqv    TEXT_SIZE 512  # Размер буфера для текста
.eqv  	RESULT_SIZE 40

.data
  input_file_name:      .space NAME_SIZE  # Имя читаемого файла
  output_file_name:  	.space NAME_SIZE  # Имя читаемого файла
  buffer:         	.space RESULT_SIZE        # Буфер для результата

.globl main
.text
main:
  read_file_name_macro("Please put input file name: ",input_file_name, NAME_SIZE, "Sorry, something wrong with filename")
  read_file_macro(input_file_name, TEXT_SIZE)
  process_min_max_wrapper a0
  format_srting(a0, a1, buffer)
  read_file_name_macro("Please put output file name: ",output_file_name, NAME_SIZE, "Sorry, something wrong with filename")
  write_file_wrapper(output_file_name, buffer, RESULT_SIZE)
  print_result_console_dialog("Do you want to print result on console ? Y/N", buffer, "Something wrong")
  end