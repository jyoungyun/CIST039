@ Jiyoung Yun - CIST039
.data
tempLocation:	.word	1

nameString:	.asciz	"Jiyoung Yun - CIST039\n"
helloString:	.asciz	"Hello World!\n"
.text
.global	main

main:
	LDR	R12, = tempLocation
	STR	LR, [R12]

	LDR	R0, = nameString	@ additional string
	BL	printf

	LDR	R0, = helloString
	BL	printf

	LDR	R12, = tempLocation
	LDR	LR, [R12]

	MOV	R0, #10			@ return value = birthday (10th)
	BX	LR
