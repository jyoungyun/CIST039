.data
hexTable:   .word   0x12345678, 0x87654321, 0xFEDCBA98, 0x01010101
            .word   0x6db6db6d, 0xCAFEF00D, 0x8BADF00D, 0xFFFFFFFF
            .word   0x00000000
nameString:	.asciz	"Jiyoung Yun (c) 2026     CIST 039\n\n"
printString:    .asciz  "Hex: \t%#010X\tBinary: "

#    for (int i = 0; i < 9; ++i) {
#        unsigned int v = arr[i];
#        printf("Hex: \t%#010X\tBinary: ", v);
#        for (int j = 31; j >= 0; --j) {
#            putchar(((v >> j)&0x01) + '0');
#        }
#        printf("\n");
#    }

# variables: arr=R4, i=R5, j=R6, v=R7, temp(v>>j)=R0

.text
.global	main

main:
    SUB	    SP, SP, #20     @ R4,R5,R6,R7,LR
    STR     LR, [SP, #16]
    STR     R7, [SP, #12]
    STR     R6, [SP, #8]
    STR     R5, [SP, #4]
    STR     R4, [SP, #0]

    LDR	    R0, =nameString
    BL	    printf

    LDR     R4, =hexTable
    MOV	    R5, #0          @ i = 0
	
Loop:
    LDR     R7, [R4, R5, LSL #2]

    MOV     R1, R7
    LDR     R0, =printString
    BL      printf

    MOV     R6, #32         @ j = 32

InLoop:
    MOV     R0, #'0'        @ R0 = '0'
    LSLS    R7, R7, #1      @ R7 = (R7 << 1) with Carry Flag
    ADC     R0, R0, #0      @ R0 = R0 + 0 + Carry
    BL      putchar

    SUBS    R6, R6, #1      @ j--
    BNE     InLoop          @ jump to InLoop if the zero flag is zero

    MOV     R0, #'\n'
    BL      putchar

    ADD     R5, R5, #1      @ i++
    CMP     R5, #9          @ i < 9
    BLT     Loop
	
    LDR     R4, [SP, #0]
    LDR     R5, [SP, #4]
    LDR     R6, [SP, #8]
    LDR     R7, [SP, #12]
    LDR     LR, [SP, #16]
    ADD     SP, SP, #20

    MOV     R0, #0
    BX      LR

