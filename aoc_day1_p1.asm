format ELF64 executable 3

segment readable executable

entry main

    ;TODO
    ; Use hard string first
    ; Declare file
    ;  Read file with open/Read
    ;  Read file with open/mmap
    ; Scan file for first digit and store
    ; Scan file for second digit in reverse and store

    ; For now, loop for each, and check if digit in range of digits




    ; Load string address into RSI
    ;     lea rsi, [input] ;or end of input?
    ; Optionally set dir?
    ; Preset RCX based to input length
    ; LODS moves current string byte @ RSI into RAX, and dir-INCs RSI
    ; CMP - Check min, can compare RAX with immediate value (mabye use dual SUBs?)
    ; SETcc - Make a logical boolean in reg or mem (could have used MOVcc?)
    ; CMP - Check max
    ; SETcc - Make logical boolean in reg or mem
    ; AND - And result reg/reg or mem/reg
    ; CMP - Check Result isn't 0
    ; LOOPcc - Loop based on the compare and RCX
    ; Store our final result
ASCII_0 = 48;
ASCII_9 = ASCII_0+9;
main:
    lea     rsi, [input]
    mov     rcx, input.size
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
    cmp     rcx, 0 ;non-0 means we found a digit
    je      exit_not_found

    mov     rdi, rax
    jmp     exit

exit_not_found:
    mov    rdi, 0
exit:
    mov    rax, 60                                  ; sys_exit
    syscall

segment readable writable

struc SizedString [string_data] {
    common
     . db string_data
     .size = $ - .
}

db '111111'
input   SizedString ''
db '111111'
