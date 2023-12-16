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
    match line, __LINE__ \{ display \`line, "): " \}
    display msg, 10
}

main:

;calculate_line_calibration_value(str.size, &str) -> u32
    todo    "Return single calibration value instead of direct sum"

    ;first digit
    ;  call string_find_digit(input.size, input)
    mov     rdi, input.size
    mov     rsi, input
    mov     rdx, SEARCH_FORWARD
    call    string_find_digit
    todo    "Check return value for NOT_FOUND_RET"
    ascdec  al
    imul    eax, 10                  ;Scale first digit to tens
    add     eax, [calibration_sum]
    mov     [calibration_sum], eax

    ;second digit
    ;  call string_find_digit(input.size, input, REVERSE)
    mov     rdi, input.size
    mov     rsi, input
    mov     rdx, SEARCH_BACKWARD
    call    string_find_digit
    todo    "Check return value for NOT_FOUND_RET"
    ascdec  al
    add     eax, [calibration_sum]
    mov     [calibration_sum], eax

    mov     rdi, rax

;exit:
    mov     rax, SYS_EXIT
    syscall

;string_find_digit(str_size, &str) -> u8
string_find_digit:
    mov     rcx, rdi

    ;Reverse?
    cmp     rdx, FALSE
    je      start_search
    add     rsi, rcx
    dec     rsi
    std

start_search:
    inc     rcx
search:
    lodsb
    cmp     al, ASCII_0
    jl      next
    cmp     al, ASCII_9
    setle   r10b
    cmp     r10b, 1
next:
    loopne  search                   ;Loop until digit found

    cmp     rcx, 0                   ;Not found
    jne     found
    mov     rax, NOT_FOUND_RET
found:
    ret

segment readable writable

struc SizedString [string_data] {
    common
     . db string_data
     .size = $ - .
}

calibration_sum dd 0

;Memory fence to check bounds
db '999999'
;TODO: Put tests in array, loop through, and assert
;input   SizedString ''
;input   SizedString 'aa'
;input   SizedString '2a'
;input   SizedString 'a2'
;input   SizedString '12'
;input   SizedString '21'
input   SizedString 'jaskdajdkfj8ssdfsdf65457464512askdf1ewyrioyisdfasd2fwersdf'
;input   SizedString 'eweiruioxcivuiwer,.m,dsfhw5eiruiuicxuviuwiqeruiuisdfsdfweir'
;Memory fence to check bounds
db '999999'
