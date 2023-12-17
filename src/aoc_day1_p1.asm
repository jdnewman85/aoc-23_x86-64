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

    ;mov     rdi, input.size
    ;lea     rsi, [input]
    ;mov     rdi, input_82.size
    ;lea     rsi, [input_82]
    mov     rdi, input_nl.size
    lea     rsi, [input_nl]
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





;fn() -> u8
test_calculate_str_calibration_value:
    push    r12

    ;input_82
    mov     rdi, input_82.size
    lea     rsi, [input_82]
    call    calculate_str_calibration_value
    mov     r12, rax

    ;input_55
    mov     rdi, input_55.size
    lea     rsi, [input_55]
    call    calculate_str_calibration_value
    add     rax, r12

    pop     r12
    ret

;fn(str.size, &str) -> u32
calculate_str_calibration_value:
    ;first digit
    push    r12                      ;Remember caller-owned
    push    rsi
    push    rdi
    mov     rdx, SEARCH_FORWARD
    ;  call string_find_digit(input.size, input, SEARCH_FORWARD)
    call    string_find_digit
    todo    "Check return value for NOT_FOUND_RET"
    ascdec  al
    imul    eax, 10                  ;Scale first digit to tens
    mov     r12, rax                 ;Store

    ;second digit
    ;  call string_find_digit(input.size, input, SEARCH_BACKWARD)
    pop     rdi                     ;Restore parameters
    pop     rsi
    mov     rdx, SEARCH_BACKWARD
    call    string_find_digit
    todo    "Check return value for NOT_FOUND_RET"
    ascdec  al
    add     eax, r12d               ;Add in first digit

    mov     rdi, rax

    pop     r12                     ;Restore caller-owned

    ret

;fn(str_size, &str, drection_bool) -> u8
string_find_digit:
    mov     rcx, rdi

    ;Reverse?
    cmp     rdx, FALSE
    je      .start_search
    add     rsi, rcx
    dec     rsi
    std

    .start_search:
    inc     rcx
    .search:
    lodsb
    cmp     al, ASCII_0
    jl      .next
    cmp     al, ASCII_9
    setle   r10b
    cmp     r10b, 1
    .next:
    loopne  .search ;Loop until digit found

    cmp     rcx, 0                   ;Not found
    jne     .found
    mov     rax, NOT_FOUND_RET
    .found:
    ret


struc SizedString [string_data] {
    common
     . db string_data
     .size = $ - .
}

segment readable writable

;Memory fence to check bounds
db '999999'
;TODO: Put tests in array, loop through, and assert
;input   SizedString ''   ;Err
;input   SizedString 'aa' ;Err
;input   SizedString '2a' ;22
;input   SizedString 'a2' ;22
;input   SizedString '12' ;12
;input   SizedString '21' ;21
input_82 SizedString 'jaskdajdkfj8ssdfsdf65457464512askdf1ewyrioyisdfasd2fwersdf' ;82
db '999999'
input_55 SizedString 'eweiruioxcivuiwer,.m,dsfhw5eiruiuicxuviuwiqeruiuisdfsdfweir' ;55
db '999999'
;input_nl SizedString 'eweiruioxcivuiwer,.m,dsfhw5eiru',10,'iuicxuvi2uwiqeruiuisd3l4fsdfweir' ; 55 + 24 == 79
input_nl SizedString 'e2w2e',10,'ivuiwer,.m,dsfhw12eiru',10,'iuicxuvi2uwiqeruiuisd3l4fsdfweir' ; 22 + 12 + 24 == 58
db '999999'
