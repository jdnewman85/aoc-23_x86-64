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
    ;first digit
    ;   call string_find_digit(input.size, input)
    mov     rdi, input.size
    mov     rsi, input
    mov     rdx, SEARCH_FORWARD
    call    string_find_digit
    ;TODO: Check for NOT_FOUND_RET
    mov     [found_digit_1], al

    ;second digit
    ;   call string_find_digit(input.size, input, REVERSE)
    mov     rdi, input.size
    mov     rsi, input
    mov     rdx, SEARCH_BACKWARD
    call    string_find_digit
    ;TODO: Check for NOT_FOUND_RET
    mov     [found_digit_2], al

    ;display
    ;   first
    lea     rsi, [found_digit_1]
    mov     rdi, STDOUT
    mov     rdx, 3
    mov     rax, SYS_WRITE
    syscall

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

found_digit_1 db '?'
found_digit_2 db '?'
nl db 10

;Memory fence to check bounds
db '999999'
;TODO: Put tests in array, loop through, and assert
;input   SizedString ''
;input   SizedString 'aa'
;input   SizedString '2a'
;input   SizedString 'a2'
;input   SizedString '12'
;input   SizedString '21'
;input   SizedString 'jaskdajdkfj8ssdfsdf65457464512askdf1ewyrioyisdfasd2fwersdf'
input   SizedString 'eweiruioxcivuiwer,.m,dsfhw5eiruiuicxuviuwiqeruiuisdfsdfweir'
;Memory fence to check bounds
db '999999'
