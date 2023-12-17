format ELF64 executable 3
segment readable executable
entry main

ASCII_0 = 48;
ASCII_9 = ASCII_0+9;
ASCII_NL = 10;

STDOUT = 1

SYS_WRITE = 1
SYS_EXIT = 60

FALSE = 0
TRUE = 1

SEARCH_FORWARD = FALSE
SEARCH_BACKWARD = TRUE

NOT_FOUND_RET = -1

NONE = 0

;ascii digit to decimal
;expects ASCII_0..=ASCII_9 value in `arg`
macro ascdec arg {
    sub     arg, ASCII_0
}

macro todo msg {
    display "TODO (", __FILE__, ":"
    match line, __LINE__ \{
        display \`line, "): "
    \}
    display msg, ASCII_NL
}

main:
    mov     rdi, day1_input.size
    lea     rsi, [day1_input]
    call    string_calibration_value_sum

    mov     rdi, rax
    mov     rax, SYS_EXIT
    syscall

;fn(str_size, &str) -> u8
;r12 - current lines, first digit dec
;r13 - current lines, last digit dec
;r14 - acc
string_calibration_value_sum:
    todo    'BUG: Zero length str'
    todo    'BUG: No digits returning 0'
    push    r14
    push    r13
    push    r12
    mov     r12, NONE
    mov     r13, NONE
    mov     r14, 0

    ;Prep rcx for loop, with size+1
    mov     rcx, rdi
    .search:
    lodsb
    ;Check if newline
    cmp     al, ASCII_NL
    jne     .digit_check
    ;Is newline
    ;-if first digit == none -> err
    cmp     r12, NONE
    je      .error_digit_not_found_line
    ;-if second digit == none -> copy from first digit
    cmp     r13, NONE
    cmove   r13, r12
    ;-calc sum += (first*10 + second)
    imul    r12, 10
    add     r14, r12
    add     r14, r13
    ;-clear current line's digits
    mov     r12, NONE
    mov     r13, NONE
    jmp     .next
    .digit_check:
    ;Check if digit
    cmp     al, ASCII_0
    jl      .next
    cmp     al, ASCII_9
    jg      .next
    ;Is a digit
    ascdec  al
    cmp     r12, NONE
    jne     .set_last
    ;-first_digit == none
    ;TODO REM: Going to scale at newline/eos evals
    ;imul    al, 10                   ;Scale
    mov     r12b, al
    jmp     .next
    .set_last:
    ;-first_digit == Some(value)
    mov     r13b, al
    .next:
    loop    .search ;Loop until eos

    ;If any remains from the last line, sum it here
    ;-if second digit == none -> copy from first digit
    cmp     r13, NONE
    cmove   r13, r12
    ;-calc sum += (first*10 + second)
    imul    r12, 10
    add     r14, r12
    add     r14, r13

    mov     rax, r14
    jmp     .return

    .error_digit_not_found_line:
    mov     rax, NOT_FOUND_RET

    .return:
    pop     r12
    pop     r13
    pop     r14
    ret

segment readable writable

day1_sample file 'inputs/day1.sample'
day1_sample.size = $ - day1_sample

day1_input file 'inputs/day1.input'
day1_input.size = $ - day1_input
