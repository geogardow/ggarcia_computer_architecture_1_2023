.section .data   @ datas from the line 1130
    datos: .word  0b1000001000001111, 0b1000001000010000,0b1000001000001100,0b1000001000000101,0b1000000111111010,0b1000000111110000,0b1000000111101110, 0b1000000111101110,0b1000000111101001,0b1000000111100000
    size: .word 10 @ real k = 2400 
    inPointer: .word 0 @ Pointer of entering values
    outPointer: .word 0 @ Pointer of getting out the values
    buffer: .word 0,0,0,0,0,0,0,0,0,0
.global _start
.section .text
@ in pointer refers to the memory address where the input offset is stored
@ out pointer refers to the memory address where the output offset is stored
@R1: Where the direction will be loaded (memory address instead of value)
@R2: Initially the whole data, then just the integer part
@R3: 1 - A
@R4: Iterator n, indicates the data index we are currently in (starting 1)
@R5: Data, just the fractional part
@R6: Initially Low, then the final processed data
@R7: Half mid
@R8: Free (until saving, it loads buffer memory addres)
@R9: If there is space or not in the buffer
@R10:To update values (load values instead of memory address)
@R11:To update values (load values instead of memory address)
@R12:Offset to get the data from the memory (4 by 4, each iteration)


@  Formula 
@ y(n) = 2.5*x(n)-1.5*x(n-k); k= 2400

_start:
    MOV R4, #1   @ Iterator n, indicates the data index we are currently in
    MOV R9, #0   @ Compare with the buffer size, indicates if there is space or not
    MOV R12, #0  @ Offset to get the data from the memory (4 by 4, each iteration)
_loop: 
    LDR R1, =datos @LDR R1, DIR_BURN
    ADD R1, R1, R12
    LDR R2, [R1] @ x(n); n = 0,1,2,....,336000, remember R12 increments in order to access the right data and in linear order
    
    LDR R1, =0b0111111111111111
    AND R1, R2, R1
    ASR R1, R1, #2
    LDR R3, =0b1000000000000000
    AND R3, R2, R3
    ADD R2, R1, R3

    @ Copying registers, this new ones will have the fraction part, and the old ones the integer part
    MOV R5, R2 @ Copy of R2 in R5, not done with mov in order to help the processor
    
    
    @ Mask to delete the integer part and leave the decimals
    @ R5 has te fractional part
    LDR R1, =0b0000111111111111 
    AND R5, R5, R1 @ Lose integer of data

    @ Shift to delete the fraction part and leave the integer
    @ R2 has the integer part
    ASR R2, R2, #12 @ Lose fractional part
    AND R2, R2, #7 @ Lose sign
    
    @ high = a*c, mid = a*d + b*c, low= b*d
    @ Multiply and shif a by c (high)
    LDR R3, =0b10 @ 2
    MUL R7, R3, R2
    LSL R7, R7, #12
    ADD R6, R6, R7

    @ Multiply and shif b by d (low)
    LDR R3, =0b0000100000000000 @ 0.5
    MUL R7, R3, R5
    ASR R7, R7, #12
    ADD R6, R6, R7

    @ Multiply b by c (half mid)
    MUL R7, R3, R2
    ADD R6, R6, R7

    @ Multiply a by d (half mid)
    LDR R3, =0b10 @ 2
    MUL R7, R3, R5
    
    @ Result y(n) without sign
    ADD R6, R6, R7

    @ TO DO: HACER ALGO PARA CUANDO n-k > 0 Hacer otro loop
    CMP R4, #6 @ It should be 2400 + 1
    BGE _addExtra

    @ get sign 
    @ To do this we reload the data because we lost it
    LDR R1, =datos
    ADD R1, R1, R12
    LDR R2, [R1] @ x(n); n = 0,1,2,....,336000

    @ Leaves just the sign
    LDR R1, =0b1000000000000000
    AND R1, R2, R1
    @ Result y(n) with sign
    ADD R6, R6, R1 @ Add the sign 

    LDR R3, =0b0111111111111111
    AND R3, R6, R3
    MOV R2, R1

    LDR R1, =0b0001000000000000
    CMP R3, R1
    BGE _adjust

    B _preStore

_addExtra:
    MOV R8, #0
    LDR R1, =datos
    LDR R2, =20 @ 2400 * 4
    SUB R1, R1, R2
    ADD R1, R1, R12
    LDR R2, [R1] @ x(n); n = 0,1,2,....,336000

    @ Mask to delete the integer part and leave the decimals
    @ R5 has te fractional part
    LDR R1, =0b0000111111111111 
    AND R5, R5, R1 @ Lose integer of data

    @ Shift to delete the fraction part and leave the integer
    @ R2 has the integer part
    ASR R2, R2, #12 @ Lose fractional part
    AND R2, R2, #7 @ Lose sign
    
    @ high = a*c, mid = a*d + b*c, low= b*d
    @ Multiply and shif a by c (high)
    LDR R3, =0b10 @ 2
    MUL R7, R3, R2
    LSL R7, R7, #12
    ADD R8, R8, R7

    @ Multiply and shif b by d (low)
    LDR R3, =0b0000100000000000 @ 0.5
    MUL R7, R3, R5
    ASR R7, R7, #12
    ADD R8, R8, R7

    @ Multiply b by c (half mid)
    MUL R7, R3, R2
    ADD R8, R8, R7

    @ Multiply a by d (half mid)
    LDR R3, =0b1 @ 1
    MUL R7, R3, R5
    
    @ Result y(n) without sign
    ADD R8, R8, R7

    @ get sign 
    @ To do this we reload the data because we lost it
    LDR R1, =datos
    LDR R2, =20 @ 2400 * 4
    SUB R1, R1, R2
    ADD R1, R1, R12
    LDR R2, [R1] @ x(n); n = 0,1,2,....,336000

    @ Leaves just the sign
    LDR R1, =0b1000000000000000
    AND R1, R2, R1

    @ Result y(n) with sign
    ADD R8, R8, R1 @ Add the sign 

    @ Verify R6 pos or neg
    LDR R1, =0b1000000000000000
    CMP R6, R1
    BGE _neg
    B _pos

_neg:
    @ Verify R8 pos or neg
    LDR R2, =0b1000000000000000
    CMP R8, R2
    BGE _notEqualSign
    MOV R2, R8
    MOV R8, R6
    MOV R6, R2
    B _equalSign

_pos:
    @ Verify R8 pos or neg
    LDR R2, =0b1000000000000000
    CMP R8, R2
    BGE _equalSign
    LDR R2, =0b0000000000000000
    B _notEqualSign

_equalSign:
    LDR R1, =0b0111111111111111
    AND R6, R6, R1
    AND R8, R8, R1
    ADD R6, R6, R8
    LDR R1, =0b0001000000000000
    CMP R6, R1
    BGE _adjust
    ADD R6, R6, R2
    B _storeValue

_notEqualSign:
    LDR R1, =0b0111111111111111
    AND R6, R6, R1
    AND R8, R8, R1
    SUB R6, R6, R8
    LDR R1, =0b0001000000000000
    CMP R6, R1
    BGE _adjust
    CMP R6, #0
    BGE _storeValue
    ADD R6, R6, R2
    B _storeValue

_adjust:
    LDR R6, =0b0100000000000000
    ADD R6, R6, R2
    B _storeValue

_preStore:
    LDR R1, =0b0111111111111111
    AND R1, R6, R1
    LSL R1, R1, #2
    LDR R2, =0b1000000000000000
    AND R2, R6, R2
    ADD R6, R1, R2
    B _storeValue

_storeValue:
    CMP R9, #5 @Verifies if there is room in the buffer
	BEQ _giveSpace

	LDR R1, =inPointer @ offset for writing and in pointer
	LDR R10, [R1]   @ value for offset
    LDR R8, =buffer
	STR R6, [R8,R10] @ Stores in buffer plus input offset
	ADD R10, R10, #4 @ Increments input offset
	STR R10, [R1] @ Store the new offset value in the pointer memory address
	
	ADD R9, R9, #1 @ We take one out of the buffer room (by incrementing occupancy)
    ADD R4, R4, #1 @ Increments processed data (index)
	
	CMP R4, #10  @ It should be 336000
	BGE _end

    ADD R12, R12, #4 @Increments data offset
    MOV R5, #0
    MOV R6, #0
    
    B _loop

_giveSpace:
    LDR R8, =inPointer @ Loads input offset memory address, we use R8 as temporal store for input offset memory address

    LDR R1, =outPointer @ Loads output offset memory address
	LDR R10, [R1] @ Loads output offset

    STR R10, [R8]

	MOV R11, #0 @ Trash known value
    LDR R8, =buffer 
	STR R11, [R8, R10] @ Stores trash value into buffer in the out position

	ADD R10, R10, #4 @ Output offset has to increment
	STR R10, [R1] @ Stores the new offset value for the out

	SUB R9, R9, #1 @ Gives room to the compare register

	B _storeValue

_end:
    MOV R7,#1
    SWI 0

