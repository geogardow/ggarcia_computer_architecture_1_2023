@ Circular buffer

.section .data
inPointer: .word 0 @ Pointer of entering values
outPointer: .word 0 @ Pointer of getting out the values
buffer: .word 0,0,0,0,0
.global _start
.section .text

_start:
	LDR R0, =buffer @ Load memory direction of the buffer
	MOV R2, #0 @ compare with buffer size
	MOV R3, #0 @ offset for reading
	MOV R4, #6 @ value to write
	MOV R5, #0 @ buffer space

_addElements:
	CMP R5, #5
	BEQ _giveSpace

	LDR R1, =inPointer @ offset for writing and in pointer
	LDR R6, [R1]   @ value for offset
	STR R4, [R0,R6]
	ADD R6, R6, #4
	STR R6, [R1] @store the new value for the pointer
	
	SUB R4, R4, #1
	ADD R5, R5, #1
	
	CMP R4, #0
	BEQ _seeElements

	B _addElements

_giveSpace:
	LDR R1, =outPointer
	LDR R6, [R1]
	MOV R10, #0
	STR R10, [R0, R6]
	ADD R6, R6, #4
	STR R6, [R1]

	LDR R1, =inPointer
	LDR R6, [R1]
	MOV R6, #0

	SUB R5, R5, #1

	B _addElements

_seeElements:
	LDR R1, [R0, R3]

	ADD R2, R2, #1
	ADD R3, R3, #4
	CMP R2, #5
	BNE _seeElements

	B _end

_deleteElements:
	CMP R5, #2  @ Empty buffer
	BEQ _end

	LDR R6, =outPointer
	LDR R9, [R6] @ value of the offset for memory that needs to be deleted
	
	MOV R8,#0 
	STR R8, [R0, R9] 
	
	ADD R9, R9, #4
	STR R9,	[R6]  @ update the out pointer
	
	SUB R5, R5, #1
	B _deleteElements


_end:
	MOV R7, #1
	SWI 0













