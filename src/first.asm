format ELF64 executable 3;

segment readable executable

macro call_stuff arg_func, arg_str {
    lea  rdi, [arg_str]
    call arg_func
}

macro call_SizedString_print arg_str {
    lea  rsi, [arg_str]
    mov  rdx, arg_str#.size
    ;mov  rdx, 17
    call SizedString_print
}

macro call_PythonString_print arg_str {
    lea  rsi, [arg_str]
    mov  rdx, arg_str#.size
    ;mov  rdx, 17
    call SizedString_print
}

main:
    ;Print prompt
;    lea    rdi, [prompt]                            ; address of msg goes into rdi
;;    mov    rax, 14                                 ; put length of msg into rax
;    call   strlen
;    mov    rdx, rax                                 ; move rax to rdx
;    mov    rsi, rdi                                 ; move rdi to rsi
;    mov    rdi, 1                                   ; stdout
;    mov    rax, 1                                   ; sys_write
;    syscall

;    call_SizedString_print prompt_sized

    call_PythonString_print prompt_python

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
    ;lea    rdi, [msg_tail]
    ;call   strlen
    call_stuff strlen, msg_tail
    mov    rsi, rdi
    mov    rdx, rax
    mov    rdi, 1                                   ; stdout
    mov    rax, 1                                   ; sys_write
    syscall

    ;Exit clean
    xor    rdi, rdi                                 ; exit code 0
    mov    rax, 60                                  ; sys_exit
    syscall

print_str:
    call_stuff strlen, rdi
    mov    rsi, rdi
    mov    rdx, rax
    mov    rdi, 1                                   ; stdout
    mov    rax, 1                                   ; sys_write
    xor    rdi, rdi
    ret

SizedString_print:
    mov    rdi, 1                                   ; stdout
    mov    rax, 1                                   ; sys_write
    syscall
    xor    rdi, rdi
    ret


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

db '||||||||||||||||||||||'
prompt   db 'What is your name?: ', 0
input    rb 64
msg_head db 'Hello ', 0
msg_tail db '!', 10, 0
db '||||||||||||||||||||||'

struc SizedString [string_data] {
    common
     . db string_data
     .size = $ - .
}

db '||||||||||||||||||||||'
prompt_sized SizedString 'Who goes there?: '
db '||||||||||||||||||||||'

struc PythonString [string_data] {
    common
     .size dd @f - $
     . db string_data
     @@:
}

db '||||||||||||||||||||||'
prompt_python PythonString 'Who is?: '
db '||||||||||||||||||||||'
