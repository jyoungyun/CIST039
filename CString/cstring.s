@ Program 6
@ cstring.s
@ Jiyoung Yun
@ 5-2026
@ CIST 039
.PSIZE 50, 100
.TITLE		"C-Strings and Byte Operations"

.DATA

courseSTR:		.ASCIZ	"Jiyoung Yun (c) 2026\t\t\tCIST 039\n"
inputSTR:		.ASCIZ	"\nEnter a string: "
.balign 4
                .SET    BUFFER_SIZE, 100
inputBuffer:    .SKIP   BUFFER_SIZE+1
countFMT:       .ASCIZ  "There are %d characters in \"%s\".\n"
vowelFMT:       .ASCIZ  "There are %d vowels in: \"%s\".\n"
upperFMT:       .ASCIZ  "Upper case first characters: \"%s\".\n"
shoutFMT:       .ASCIZ  "Shouting: \"%s\".\n"
removeFMT:      .ASCIZ  "Extra spaces removed: \"%s\".\n"

.EJECT			// Form feed / New Page
.SBTTL		"The Code for the Program"
.TEXT
.GLOBAL	main

main:
    STMDB       SP!, {FP, LR}
    MOV         FP, SP

	LDR		    R0, =courseSTR		/*Course Title*/ 
	BL		    puts

	LDR		    R0, =inputSTR
	BL		    printf

    LDR         R0, =inputBuffer
    LDR         R1, =BUFFER_SIZE
    BL          getline

    LDR         R0, =inputBuffer
    LDRB        R0, [R0]
    CMP         R0, #00
    BEQ         Done

    LDR         R0, =inputBuffer
    BL          puts

    LDR         R0, =inputBuffer
    BL          countCharacters
    MOV         R1, R0
    LDR         R0, =countFMT
    LDR         R2, =inputBuffer
    BL          printf

    LDR         R0, =inputBuffer
    BL          countVowels
    MOV         R1, R0
    LDR         R0, =vowelFMT
    LDR         R2, =inputBuffer
    BL          printf

    LDR         R0, =inputBuffer
    BL          upperFirstChar
    LDR         R0, =upperFMT
    LDR         R1, =inputBuffer
    BL          printf

    LDR         R0, =inputBuffer
    BL          shouting
    LDR         R0, =shoutFMT
    LDR         R1, =inputBuffer
    BL          printf

    LDR         R0, =inputBuffer
    BL          removeSpace
    LDR         R0, = removeFMT
    LDR         R1, =inputBuffer
    BL          printf

Done:
    LDMIA   SP!, {FP, LR}
	MOV		R0, #0			// Return Code of 0	
	BX		LR

getline:
    // Read the string
    //
    // Input:
    //  R0  Is the Address of the start of the string
    //  R1  Is the maximum length of the string
    // Output:
    //  none
    STMDB   SP!, {R5, FP, LR}
    MOV     FP, SP
    STMDB   SP!, {R0, R1}   @ [FP-8] = R0
                            @ [FP-4] = R1

    MOV     R5, #0     @ index = 0

readLoop:
    BL      getchar
    CMP     R0, #'\n'
    BEQ     readDone

    LDR     R1, [FP, #-4]
    CMP     R5, R1
    BGE     readDone

    LDR     R1, [FP, #-8]
    STRB    R0, [R1, R5]
    ADD     R5, R5, #1
    B       readLoop

readDone:
    MOV     R0, #0
    LDR     R1, [FP, #-8]
    STRB    R0, [R1, R5]

    LDMIA   SP!, {R0, R1}
    LDMIA   SP!, {R5, FP, LR}
    BX      LR

countCharacters:
    // Count characters of the input string
    //
    // Input:
    //  R0  Is the Address of the start of the string
    // Output:
    //  R0  Is the count of characters
    STMDB   SP!, {FP, LR}
    MOV     FP, SP

    MOV     R1, R0
    MOV     R0, #0

countCharactersLoop:
    LDRB    R2, [R1]
    CMP     R2, #00
    BEQ     countCharactersDone

    ADD     R0, R0, #1
    ADD     R1, R1, #1
    B       countCharactersLoop

countCharactersDone:
    LDMIA   SP!, {FP, LR}
    BX      LR

toupper:
    // To Upper
    //
    // Input:
    //  R0  Is the character
    // Output:
    //  R0  Is the upper character
    STMDB   SP!, {FP, LR}
    MOV     FP, SP

    CMP     R0, #'a'
    BLT     toupperDone

    CMP     R0, #'z'
    BGT     toupperDone

    SUB     R0, R0, #32    

toupperDone:
    LDMIA   SP!, {FP, LR}
    BX      LR

countVowels:
    // Count vowels in the input string
    //
    // Input:
    //  R0  Is the Address of the start of the string
    // Output:
    //  R0  Is the vowels count
    STMDB   SP!, {FP, LR}
    MOV     FP, SP

    MOV     R1, R0
    MOV     R0, #0

countVowelsLoop:
    LDRB    R2, [R1]
    CMP     R2, #00
    BEQ     countVowelsDone

    STMDB   SP!, {R0, R1}
    MOV     R0, R2
    BL      toupper
    MOV     R2, R0
    LDMIA   SP!, {R0, R1}

    CMP     R2, #'A'
    BEQ     isVowel
    CMP     R2, #'E'
    BEQ     isVowel   
    CMP     R2, #'I'
    BEQ     isVowel
    CMP     R2, #'O'
    BEQ     isVowel
    CMP     R2, #'U'
    BEQ     isVowel
    B       next

isVowel:
    ADD     R0, R0, #1
next:
    ADD     R1, R1, #1
    B       countVowelsLoop

countVowelsDone:
    LDMIA   SP!, {FP, LR}
    BX      LR

upperFirstChar:
    // Upper case the first letter of each word in the input string
    //
    // Input:
    //  R0  Is the Address of the start of the string
    STMDB   SP!, {R4, R5, FP, LR}
    MOV     FP, SP
    STMDB   SP!, {R0}       @ [FP-4] = R0

    MOV     R4, #1          @ first char should be capitalized
    MOV     R5, #0          @ index

upperFirstCharLoop:
    LDR     R1, [FP, #-4]
    LDRB    R0, [R1, R5]
    CMP     R0, #00
    BEQ     upperFirstCharDone

    CMP     R0, #' '
    MOVEQ   R4, #1
    ADDEQ   R5, R5, #1
    BEQ     upperFirstCharLoop

    CMP     R4, #0
    BEQ     upperFirstCharNext

    BL      toupper
    LDR     R1, [FP, #-4]
    STRB    R0, [R1, R5]

upperFirstCharNext:
    MOV     R4, #0
    ADD     R5, R5, #1
    B       upperFirstCharLoop

upperFirstCharDone:
    LDMIA   SP!, {R0}
    LDMIA   SP!, {R4, R5, FP, LR}
    BX      LR

shouting:
    // Uppercase Every laatter in the string
    //
    // Input:
    //  R0  Is the Address of the start of the string
    STMDB   SP!, {R5, FP, LR}
    MOV     FP, SP
    STMDB   SP!, {R0}       @ [FP-4] = R0

    MOV     R5, #0          @ index

shoutingLoop:
    LDR     R1, [FP, #-4]
    LDRB    R0, [R1, R5]
    CMP     R0, #00
    BEQ     shoutingLoopDone

    BL      toupper
    LDR     R1, [FP, #-4]
    STRB    R0, [R1, R5]

    ADD     R5, R5, #1
    B       shoutingLoop

shoutingLoopDone:
    LDMIA   SP!, {R0}
    LDMIA   SP!, {R5, FP, LR}
    BX      LR

removeSpace:
    // Remove the excesses spaces in the string
    //
    // Input:
    //  R0  Is the Address of the start of the string
    STMDB   SP!, {FP, LR}
    MOV     FP, SP

//int j = 0;
//for (int i = 0; i < length) {
//    if (str[i] != ' ')
//        flag = 0, str[j++] = str[i++];
//    if (str[i] == ' ' && flag == 0)
//        flag = 1; str[j++] = str[i++];
//    if (str[i] == ' ' && flag == 1)
//        i++;
//        continue;

    MOV     R1, #0          @ flag
    MOV     R2, #0          @ read index
    MOV     R3, #0          @ write index

removeSpaceLoop:
    LDRB    R12, [R0, R2]
    CMP     R12, #00
    BEQ     removeSpaceDone

    CMP     R12, #' '
    MOVNE   R1, #0
    BNE     removeSpaceNext

    CMP     R1, #1
    ADDEQ   R2, R2, #1
    BEQ     removeSpaceLoop

    MOV     R1, #1

removeSpaceNext:
    STRB    R12, [R0, R3]
    ADD     R2, R2, #1
    ADD     R3, R3, #1
    B       removeSpaceLoop

removeSpaceDone:
    MOV     R12, #00
    STRB    R12, [R0, R3]

    LDMIA   SP!, {FP, LR}
    BX      LR

