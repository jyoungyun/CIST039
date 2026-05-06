@ Program 5
@ FloatDecode.s
@ Jiyoung Yun
@ 4-2026
@ CIST 039
.PSIZE 50, 100
.TITLE		"Float Decoding"

.DATA

courseSTR:		.ASCIZ	"Jiyoung Yun (c) 2026\t\t\tCIST 039\n"
pgmSTR:			.ASCIZ	"This program will input and decode an IEEE-754 Floating Point Numbers. It will square the number and decode it. Next, if possible, it will take the square root of the number and decode it. This will repeat until the user enters Zero."

inputSTR:		.ASCIZ	"\nEnter the single precision floating point value (0 to exit): "
.balign 4
fltInput:       .SKIP   4
inputFMT:       .STRING "%f"
posFMT:         .STRING "+1."
negFMT:         .STRING "-1."
expFMT:         .STRING " E%d\n"

initSTR:        .ASCIZ  "The initial value is:     "
squaredSTR:     .ASCIZ  "The value squared is:     "
rootSTR:        .ASCIZ  "The root of the value is: "
infSTR:         .ASCIZ  "inf\n"

.EJECT			// Form feed / New Page
.SBTTL		"The Code for the Program"
.TEXT
.GLOBAL	main

main:
    // TODO: Save stack
    STMDB   SP!, {R4,LR}

	LDR		    R0, =courseSTR		/*Course Title*/ 
	BL		    puts
	
	LDR		    R0, =pgmSTR		    /*The Program Title*/ 
	BL		    puts
	
LOOP:
	LDR		    R0, =inputSTR
	BL		    printf
	
    LDR         R1, =fltInput
    LDR         R0, =inputFMT
    BL          scanf

    LDR         R1, =fltInput
    VLDR.32     S0, [R1]

    VMOV        R4, S0
    CMP         R4, #0
    BEQ         EXIT

    LDR         R0, =initSTR
    BL          printf
    VMOV        R0, S0
    BL          printFloat

    VMUL.F32    S1, S0, S0
    LDR         R0, =squaredSTR
    BL          printf

    VMOV        R0, S1
    LDR         R1, =0x7F800000
    AND         R2, R0, R1
    CMP         R2, R1
    BEQ         DetectInf
    BL          printFloat
    B           SquaredDone
DetectInf:
    LDR         R0, =infSTR
    BL          printf
SquaredDone:

    CMP         R4, #0
    BMI         LOOP

    VSQRT.F32   S2, S0
    LDR         R0, =rootSTR
    BL          printf
    VMOV        R0, S2
    BL          printFloat
   
    B           LOOP
EXIT:
    LDMIA   SP!, {R4,LR}

	MOV		R0, #0			// Return Code of 0	
	BX		LR

printFloat:
    // Display the decode string of float number.
    //
    // Input: Parameters
    //  R0  Float value
    //
    // Output: Return values
    //  None
    // 
    STMDB   SP!, {R5,R6,R7,LR}

    MOV     R5, R0

    // Sign
    LDR     R0, =posFMT
    TST     R5, #0x80000000
    BPL     SignDone
    LDR     R0, =negFMT
SignDone:
    BL      printf

    // fraction
    LSL     R6, R5, #9
    MOV     R7, #23         @ j = 23
FracLoop:
    MOV     R0, #'0'
    TST     R6, #0x80000000
    BEQ     FracDone
    MOV     R0, #'1'
FracDone:
    BL      putchar
    LSL     R6, R6, #1
    SUBS    R7, R7, #1
    BNE     FracLoop

    // Exponent
    LSLS    R1, R5, #1
    LSR     R1, R1, #24
    SUB     R1, R1, #127

    LDR     R0, =expFMT
    BL      printf

    LDMIA   SP!, {R5,R6,R7,LR}
    BX      LR

