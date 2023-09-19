.global _start

.section .data
    a: .word 0b0000000110000000
    b: .word 0b0000001101000000

.text
_start:
    @ Load of a and b
    ldr r0, =a
    ldr r1, [r0]
    
    ldr r0, =b
    ldr r2, [r0]
    
    @ Adding them
    add r5, r1, r2
    
    @ Copying registers, this new ones will have the fraction part, and the old ones the integer part
    mov r3, r1
    mov r4, r2
    
    @ Mask to delete the integer part and leave the decimals
    and r3, r3, #0xff
    and r4, r4, #0xff
    
    @ Shift to delete the fraction part and leave the integer
    asr r1, r1, #8
    asr r2, r2, #8  
    
    b end
     
end:
    mov r7, #1        
    mov r0, #0        
    svc 0             
        
    
