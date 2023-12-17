TODO
- [X] Use hard string first
  - [*] Multi-line
- [ ] Declare file
- [ ]  Read file with open/Read
- [ ]  Read file with open/mmap
- [X] Scan file for first digit and store
- [X] Scan file for second digit in reverse and store

- [X] For now, loop for each char, and check if digit in range of digits
- [ ] Check zero and sign extending and conversions everywhere




















Find digit alg
 Load string address into RSI
     lea rsi, [input] ;or end of input?
 Optionally set dir?
 Preset RCX based to input length
 LODS moves current string byte @ RSI into RAX, and dir-INCs RSI
 CMP - Check min, can compare RAX with immediate value (mabye use dual SUBs?)
 SETcc - Make a logical boolean in reg or mem (could have used MOVcc?)
 CMP - Check max
 SETcc - Make logical boolean in reg or mem
 AND - And result reg/reg or mem/reg
 CMP - Check Result isn't 0
 LOOPcc - Loop based on the compare and RCX
 Store our final result
