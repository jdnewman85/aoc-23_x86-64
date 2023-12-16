format ELF64 executable 3

segment readable executable

entry main

main:
    ;Exit clean
    xor    rdi, rdi                                 ; exit code 0
    mov    rax, 60                                  ; sys_exit
    mov 
    syscall
