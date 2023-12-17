format ELF64 executable 3
segment readable executable
entry main

ASCII_0 = 48;
ASCII_9 = ASCII_0+9;

STDOUT = 1

SYS_WRITE = 1
SYS_EXIT = 60

FALSE = 0
TRUE = 1

SEARCH_FORWARD = FALSE
SEARCH_BACKWARD = TRUE

NOT_FOUND_RET = -1

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
    display msg, 10
}

main:
    ;push    r12

    ;.first:
    mov     rdi, input_82.size
    lea     rsi, [input_82]
    call    calculate_line_calibration_value
    mov     r12, rax

    ;.second:
    mov     rdi, input_55.size
    lea     rsi, [input_55]
    call    calculate_line_calibration_value
    add     rax, r12

    ;pop     r12

    mov     rdi, rax
    mov     rax, SYS_EXIT
    syscall

;calculate_line_calibration_value(str.size, &str) -> u32
calculate_line_calibration_value:
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

;string_find_digit(str_size, &str, drection_bool) -> u8
string_find_digit:
    mov     rcx, rdi

    ;Reverse?
    cmp     rdx, FALSE
    je      string_find_digit.start_search
    add     rsi, rcx
    dec     rsi
    std

    .start_search:
    inc     rcx
    .search:
    lodsb
    cmp     al, ASCII_0
    jl      string_find_digit.next
    cmp     al, ASCII_9
    setle   r10b
    cmp     r10b, 1
    .next:
    loopne  string_find_digit.search ;Loop until digit found

    cmp     rcx, 0                   ;Not found
    jne     string_find_digit.found
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
