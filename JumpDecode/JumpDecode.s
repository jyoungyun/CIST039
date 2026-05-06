@ Program 4
@ JumpDecode.s
@ Howard Miller
@ 9-2019 3-2022
@ Jiyoung Yun
@ 3-2026
@ CIST 039
.PSIZE 50, 100
.TITLE		"ARM Jump Decoding"
.SBTTL		"Data Section"	


.DATA

courseSTR:		.ASCIZ	"Jiyoung Yun (c) 2026\t\t\tCIST 039\n"
pgmSTR:			.ASCIZ	"This program will Decode a subset of ARM instructions\n"
titleSTR:		.ASCIZ	"Address\t\tM Language\tInstruction"


printSTR:		.ASCIZ	"0x%08X\t%08X\t"
printBranchOff:	.STRING	"\t<%+d>"

printSTRing:	.STRING	"%s"

/* STRINGS for Opcode		*/
unknownIns:		.STRING "UNKNOWN INSTRUCTION"

/*
	Opcode Strings for Brank / Branch and Link InSTRuctions...4 bytes each
*/

branchMnemonics:
//			Null Terminate Label with Space (4 Bytes...HINT!)			
			.STRING	"EQ "	// 0000		- Bit vales in CC field
			.STRING	"NE "	// 0001
			.STRING	"CS "	// 0010
			.STRING	"CC "	// 0011
			.STRING	"MI "	// 0100
			.STRING	"PL "	// 0101
			.STRING	"VS "	// 0110
			.STRING	"VC " 	// 0111
			.STRING	"HI "	// 1000
			.STRING	"LS "	// 1001
			.STRING	"GE "	// 1010
			.STRING	"LT "	// 1011
			.STRING	"GT "	// 1100
			.STRING	"LE "	// 1101
			.STRING	"   "	// 1110		// Just a Branch B / BL
			.STRING	"xx "	// 1111		// Reserved, never use

/*
shiftInSTRuctionCC	=28
maskInSTRuctionCC	=0b1111

shiftLinkFlag		=24

shiftMajorOpcode	= 25
maskMajorOpcode		= 0b0000111
*/


							
.EJECT			// Form feed / New Page
.SBTTL		"The Code for the Program"
.TEXT
.GLOBAL	main

main:
/*\_/\/\_/\/\_/\/\_/\/\_/\/\_/\/
Your Code Goes Here to Save registers
\_/\/\_/\/\_/\/\_/\/\_/\/\_/\/*/
    SUB     SP, #16
    STR     LR, [SP, #0]
    STR     R4, [SP, #4]
    STR     R5, [SP, #8]
    STR     R9, [SP, #12]

	LDR		R0, =courseSTR		/*Class Title*/ 
	BL		puts
	
	LDR		R0, =pgmSTR		/*The Program Title*/ 
	BL		puts
	
	LDR		R0, =titleSTR	// Column header
	BL		puts
	
	LDR		R5, =TestCodeToDecode	
	MOV		R4, #0			// Loop Counter and Index
LOOP:
/*\_/\/\_/\/\_/\/\_/\/\_/\/\_/\/
Code Start
\_/\/\_/\/\_/\/\_/\/\_/\/\_/\/*/
    LDR     R0, =printSTR
    ADD     R12, R5, R4, LSL #2     // R12 = &array[i]
    MOV     R1, R12
    LDR     R9, [R5, R4, LSL #2]    // R9 = array[i]
    MOV     R2, R9
    BL      printf

    MOV     R1, #0b111
    ANDS    R1, R1, R9, LSR #25
    TEQ     R1, #0b101              // Check whether it is branch or not
    BNE     notBranchInstruction    // if not, jump to notBranch...

    MOV     R0, #'B'
    BL      putchar                 // if Branch, print 'B'

    TST     R9, #1 << 24
    BEQ     BranchInstruction

    MOV     R0, #'L'
    BL      putchar                 // if Link, print 'L'

BranchInstruction: 
    LDR     R3, =branchMnemonics
    LSR     R12, R9, #28            // R12 = CC
    ADD     R1, R3, R12, LSL #2     // R1 = &R3[R12]
    LDR     R0, =printSTRing
    BL      printf    

Offset:
    LSL     R12, R9, #8              // Offset << 8
    ASR     R1, R12, #6              // Offset (signed)>> 6 (add 0b00)
    ADD     R1, R1, #8               // Apply prefetch(2 instructions)
    LDR     R0, =printBranchOff
    BL      printf

    B       LoopNext
/*\_/\/\_/\/\_/\/\_/\/\_/\/\_/\/
Code End
\_/\/\_/\/\_/\/\_/\/\_/\/\_/\/*/
notBranchInstruction:
	LDR		R0, =unknownIns
	BL		printf

LoopNext:
	MOV		R0, #'\n'
	BL		putchar

	ADD		R4, R4, #1
	CMP		R4, #20		// Read 20 Instructions
	BLT		LOOP

ProgramExit:
/*\_/\/\_/\/\_/\/\_/\/\_/\/\_/\/
Your Code Goes Here to Restore registers
\_/\/\_/\/\_/\/\_/\/\_/\/\_/\/*/	
    LDR     R9, [SP, #12]    
    LDR     R5, [SP, #8]
    LDR     R4, [SP, #4]
    LDR     LR, [SP, #0]
    ADD     SP, #16	

	MOV		R0,#0			// Return Code of 0	
	BX		LR


/*
This is random test code.  It has no functional meaning.  It is here
to create bits in memory for us to decode!
*/	
TestCodeToDecode:
	BEQ		T2
	BLNE	TestCodeToDecode
	.WORD	0xFFFFFFFF
	.WORD	0X00000000
	BMI		T2
	MOV		R1, R2
	BLPL	T2
	BCS		T2
	BLHI	TestCodeToDecode
	BLS		T2
	BLGT	T2
	BLLT	main
	BGE		T2
	.ASCII	"ABCD"
	BLCC	T2
	BVS		T2
	BLVC	T2
	BLE		T2
	B		T2
	BL		TestCodeToDecode
T2:
	ANDS	R3, R5, R9, ASR	#7
	CMP		R5, r7
	CMP		R6, #25

	CMN		R11, R13
	ADD		R0,R7,R2
	ORR		R11,R12,R10
