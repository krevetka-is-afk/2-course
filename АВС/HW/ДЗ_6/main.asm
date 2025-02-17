.include "strcopy.s"
.include "macros.s"
.include "data.s"

.text
.global main

main:
    # test string input 
    print_string msg_src

    la a0, buffer_src
    li a1, 128
    read_string()

    la t0, buffer_dest
    la t1, buffer_src
    strcpy t0, t1

    print_string msg_res
    print_string buffer_dest
    print_string msg_newline
    
    j test1

    # test string
test1:
    la t0, buffer_dest
    la t1, test1_src
    strcpy t0, t1

    print_string msg_res
    print_string buffer_dest
    print_string msg_newline
    
    j test2

    # test another string
test2:
    la t0, buffer_dest
    la t1, test2_src
    strcpy t0, t1

    print_string msg_res
    print_string buffer_dest
    print_string msg_newline
    
    j test3
    
    # test numbers
test3:
    la t0, buffer_dest
    la t1, test3_src
    strcpy t0, t1

    print_string msg_res
    print_string buffer_dest
    print_string msg_newline
    
    j end_main

end_main:
    li a7, 10
    ecall
    
