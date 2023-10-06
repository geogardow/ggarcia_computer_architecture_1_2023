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
	MOV R4, #0 @ value to write
	MOV R5, #0 @ buffer space

_addElements:
	CMP R5, #4
	BEQ _giveSpace

	LDR R1, =inPointer @ offset for writing and in pointer
	LDR R6, [R1]   @ value for offset
	STR R4, [R0,R6]
	ADD R6, R6, #4
	STR R6, [R1] @store the new value for the pointer
	
	ADD R4, R4, #1
	ADD R5, R5, #1
	
	CMP R4, #12
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

	SUB R5, R5, #1

	CMP R6, #20
	BNE _addElements

	MOV R6, #0
	STR R6, [R1]

	B _addElements


_seeElements:
	LDR R1, [R0, R3]

	ADD R2, R2, #1
	ADD R3, R3, #4
	CMP R2, #5
	BNE _seeElements

	B _end

_end:
	MOV R7, #1
	SWI 0













