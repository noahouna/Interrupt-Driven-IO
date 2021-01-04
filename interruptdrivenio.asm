.ORIG x800

    ; (1) Initialize interrupt vector table.
    LD R0, VEC
    LD R1, ISR
    STR R1, R0, #0

    ; (2) Set bit 14 of KBSR.
    LDI R0, KBSR
    LD R1, MASK
    NOT R1, R1
    AND R0, R0, R1
    NOT R1, R1
    ADD R0, R0, R1
    STI R0, KBSR

    ; (3) Set up system stack to enter user space.
    LD R0, PSR
    ADD R6, R6, #-1
    STR R0, R6, #0
    LD R0, PC
    ADD R6, R6, #-1
    STR R0, R6, #0
    ; Enter user space.
    RTI
        
VEC     .FILL x0180
ISR     .FILL x1000
KBSR    .FILL xFE00
MASK    .FILL x4000
PSR     .FILL x8002
PC      .FILL x3000

.END

.ORIG x3000

START ; User program to print numbers	

    AND R0, R0, #0	; initialization
	AND R1, R0, #0
	AND R2, R0, #0
	AND R3, R0, #0
	AND R4, R0, #0
	AND R5, R0, #0
	AND R6, R0, #0
	AND R7, R0, #0

    LEA R6, START      ; initialize stack pointer to x2FFF           


; Put the ASCII values into memory

    LD R0, VALS ; Reads x4000 to R0
    LD R1, ZERO
    LD R2, SPC
    LD R3, NEWLN

SET	
    STR R1, R0, #0
	LD R4, NINE
	NOT R4, R4
	ADD R4, R4, #1
	ADD R4, R1, R4
	BRz NEWLINE
	STR R2, R0, #1
	ADD R0, R0, #2
	ADD R1, R1, #1
	BR SET
	
NEWLINE	
    STR R3, R0, #1

	LD R4, VALS ; pointer to x4000

PRINT	
    LDR R0, R4, #0
	ADD R4, R4, #1
	OUT
	LDI R1, COUNT
DELAY   
    ADD R1, R1, #-1
	BRp DELAY
	LD R5, NEWLN
	NOT R5, R5
	ADD R5, R5, #1
	ADD R5, R0, R5
	BRz NEWLINE
	BR PRINT
	
	

HALT

;;;;;;;;;;;;;
;;Constants;;
;;;;;;;;;;;;;

SPC     .FILL x0020
NEWLN   .FILL x000A
COUNT   .FILL x3000
ZERO    .FILL x0030
ONE     .FILL x0031
TWO     .FILL x0032
THREE   .FILL x0033
FOUR    .FILL x0034 
FIVE    .FILL x0035
SIX     .FILL x0036
SEVEN   .FILL x0037
EIGHT   .FILL x0038
NINE    .FILL x0039
VALS    .FILL x4000
IENABLE .FILL x4000
VECT    .FILL x0180
.BLKW x80
.FILL x2000

.END

.ORIG x2000

; Start of interrupt program to print whatever key was pressed by user to console

    ADD R6, R6, #-1     ; Save registers from user program onto stack
    STR R0, R6, #0
    ADD R6, R6, #-1
    STR R1, R6, #0
    ADD R6, R6, #-1
    STR R2, R6, #0
    ADD R6, R6, #-1
    STR R3, R6, #0
    ADD R6, R6, #-1
    STR R4, R6, #0
    ADD R6, R6, #-1
    STR R5, R6, #0
    ADD R6, R6, #-1
    STR R6, R6, #0
    ADD R6, R6, #-1
    STR R7, R6, #0
    LDI R0, KBDR
    
READY 
    LD R2, DSR
    BRn DISP
    BRzp READY

DISP  
    STI R0, DDR
  
    LDI R1, CNT
BUF   
    ADD R1, R1, #-1
    BRp BUF
    LD R1, TALLY
    ADD R1, R1, #1
 
    ST R1, TALLY
    ADD R1, R1, #-5
    BRnp READY

    AND R1, R1, #0   ; reset counter
    ST R1, TALLY


    LDR R7, R6, #0     ; Restore registers of user program from stack
    ADD R6, R6, #1
    LDR R6, R6, #0
    ADD R6, R6, #1
    LDR R5, R6, #0
    ADD R6, R6, #1
    LDR R4, R6, #0
    ADD R6, R6, #1
    LDR R3, R6, #0
    ADD R6, R6, #1
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R1, R6, #0
    ADD R6, R6, #1
    LDR R0, R6, #0
    ADD R6, R6, #1

    RTI


    TALLY .BLKW #1




;;;;;;;;;;;;;
;;Constants;;
;;;;;;;;;;;;;

    KBDR .FILL xFE02
    DSR  .FILL xFE04
    DDR  .FILL xFE06
    CNT  .FILL x3000

.END