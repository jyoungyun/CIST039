.data
tempLR:		.word	1
tempR4:		.word	1

nameString:	.asciz	"Jiyoung Yun (c) 2026     CIST 039\n\n"
titleString:	.asciz	"Number\tSquared\n"
printString:	.asciz	"%d\t%d\n"

.text
.global	main

#printf("Number\tSquared\n");
#for (int i = 0; i < 100; ++i) {
#  printf("%d\t%d\n", i, i*i);
#}

#R4 =i
#R1 =R4, R2 squared value

main:
	LDR	R12, =tempLR
	STR	LR, [R12]

	LDR	R12, =tempR4
	STR	R4, [R12]

	LDR	R0, =nameString
	BL	printf

	LDR	R0, =titleString
	BL	printf

	MOV	R4, #0
	
Loop:
	MUL	R2, R4, R4
	MOV	R1, R4
	LDR	R0, =printString
	BL	printf

	ADD	R4, R4, #1	@ i++
	CMP	R4, #99		@ i <= 99
	BLE	Loop
	
	LDR	R12, =tempR4
	LDR	R4, [R12]

	LDR	R12, =tempLR
	LDR	LR, [R12]

	MOV	R0, #0
	BX	LR


