format ELF64 executable 3

segment readable executable

entry main

main:
    ;Print prompt
    lea    rdi, [prompt]                            ; address of msg goes into rdi
;    mov    rax, 14                                 ; put length of msg into rax
    call   strlen
    mov    rdx, rax                                 ; move rax to rdx
    mov    rsi, rdi                                 ; move rdi to rsi
    mov    rdi, 1                                   ; stdout
    mov    rax, 1                                   ; sys_write
    syscall

    ;Read from stdin
    lea    rsi, [input]
    mov    rdx, 64
    mov    rdi, 0
    mov    rax, 0
    syscall

    ;Print msg_head
    lea    rdi, [msg_head]
    call   strlen
    mov    rsi, rdi
    mov    rdx, rax
    mov    rdi, 1                                   ; stdout
    mov    rax, 1                                   ; sys_write
    syscall

    ;Print name
    lea    rdi, [input]
    call   strlen
    mov    rsi, rdi
    mov    rdx, rax
    sub    rdx, 2
    mov    rdi, 1                                   ; stdout
    mov    rax, 1                                   ; sys_write
    syscall

    ;Print msg_tail
    lea    rdi, [msg_tail]
    call   strlen
    mov    rsi, rdi
    mov    rdx, rax
    mov    rdi, 1                                   ; stdout
    mov    rax, 1                                   ; sys_write
    syscall

    ;Exit clean
    xor    rdi, rdi                                 ; exit code 0
    mov    rax, 60                                  ; sys_exit
    syscall

strlen:
    ;Save registers
    push   rdi
    push   rcx

    ;Init rcx
    sub    rcx, rcx
    mov    rcx, -1
    ;Clear al and direction
    sub    al, al
    cld

    ;Count till null str
    repne  scasb
    neg    rcx
    sub    rcx, 1
    mov    rax, rcx
    pop    rcx
    pop    rdi
    ret

segment readable writable

prompt   db 'What is your name?: ', 0
input    rb 64
msg_head db 'Hello ', 0
msg_tail db '!', 10, 0
