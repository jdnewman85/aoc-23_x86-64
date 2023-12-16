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

main:

;calculate_line_calibration_value(str.size, &str) -> u
    ;first digit
    ;   call string_find_digit(input.size, input)
    mov     rdi, input.size
    mov     rsi, input
    mov     rdx, SEARCH_FORWARD
    call    string_find_digit
    ;TODO: Check for NOT_FOUND_RET
    sub     al, ASCII_0              ;Convert to dec
    imul    eax, 10 ;Scale
    add     eax, [calibration_sum]
    mov     [calibration_sum], eax

    ;second digit
    ;   call string_find_digit(input.size, input, REVERSE)
    mov     rdi, input.size
    mov     rsi, input
    mov     rdx, SEARCH_BACKWARD
    call    string_find_digit
    ;TODO: Check for NOT_FOUND_RET
    sub     al, ASCII_0              ;Convert to dec
    add     eax, [calibration_sum]
    mov     [calibration_sum], eax

    mov     rdi, rax

;exit:
    mov     rax, SYS_EXIT
    syscall

; rdi - haystack size - u64
; rsi - haystack - string - const char *buf
; ras - found: ascii digit - char
;       error: -1
string_find_digit:
    mov     rcx, rdi

    cmp     rdx, FALSE
    je      start_search
    ;Let's try to do reverse
    add     rsi, rcx
    dec     rsi
    std
    ;End reverse

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
    loopne  search ;Loop until digit

    cmp     rcx, 0 ;Not found
    jne     found
    mov    rax, NOT_FOUND_RET
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
