.section .data
    datos: .word  0b1000001000001111, 0b1000001000010000,0b1000001000001100,0b1000001000000101,0b1000000111111010,0b1000000111110000,0b1000000111101110, 0b1000000111101110,0b1000000111101001,0b1000000111100000
    minus_a: .word 0b10000000000000 @ Decimal(1/1-a=0.5)
    a: .word 0b0010011001100110 @ a = 0.6
    size: .word 10 @ real k = 2400 
    inPointer: .word 0 @ Pointer of entering values
    outPointer: .word 0 @ Pointer of getting out the values
    buffer: .word 0,0,0,0,0,0,0,0,0,0
.global _start
.section .text

@  Formula 
@ y(n) = (1-a)*x(n)+a*y(n-k); k= 2400


_start:
    LDR R1, =minus_a
    LDR R3, [R1] @ 1-a
    ADD R4, R4, #1   @ Iterator
    LDR R8, =buffer  @ pointer of the buffer
    ADD R9, R9, #0   @ compare with the buffer size
    ADD R12, R12, #0
_loop:
    LDR R1, =datos
    LDR R2, [R1, R12] @ x(n); n = 0,1,2,....,336000
    @ Copying registers, this new ones will have the fraction part, and the old ones the integer part
    ADD R5, R5, R2

    @ Mask to delete the integer part and leave the decimals
    AND R5, R5, #0xff
    AND R3, R3, #0xff

    @ Shift to delete the fraction part and leave the integer
    ASR R2, R2, #14

    @ high = 0, mid = b*c, low= b*d
    @ Multiply and shif b by d (low)
    MUL R6, R3, R2
    ASR R6, R6, #14

    @ Multiply b by c (half mid)
    MUL R7, R3, R5

    @ Result y(n)
    ADD R6, R6, R7

    @ TO DO: HACER ALGO PARA CUANDO n-k > 0 hacer otro loop

    ADD R4, R4, #1
    CMP R4, #10
    BLE _storeValue

    B _end

_storeValue:
    CMP R9, #10
	BEQ _giveSpace

	LDR R1, =inPointer @ offset for writing and in pointer
	LDR R10, [R1]   @ value for offset
	STR R6, [R8,R10]
	ADD R10, R10, #4
	STR R10, [R1] @store the new value for the pointer
	
	ADD R9, R9, #1
	
	CMP R9, #10  @ It should be 336000
	BGE _end

    ADD R12, R12, #4

    B _loop

_giveSpace:
    LDR R1, =outPointer
	LDR R10, [R1]
	ADD R11, R11,#0
	STR R11, [R1, R10]
	ADD R10, R10, #4
	STR R10, [R1]

	LDR R1, =inPointer
	LDR R10, [R1]

	SUB R9, R9, #1

	CMP R10, #10    @ It should be 336000 
	BLE _loop

	ADD R10, R10,#0
	STR R10, [R1]

	B _loop

_end:
    MOV R7,#1
    SWI 0