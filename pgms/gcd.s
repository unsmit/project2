// gcd.s - Compute the greatest common divisor of 2 ints
//   Read 2 ints at memory 4000 and 40004
//    Store gcd at 4008
	MOV	X0,#4000
	LD	X1,[X0,#0]
	LD	X2,[X0,#4]
	CBZ	X1,#9 // Top of Loop
	SUB	X3,X1,X2
	CBNEG	X3,#3 // If X1<X2, goto switch
	ADDI	X1,X3,#0 // X1=X1-X2
	B       #-4 // Loop
	ADDI	X3,X1,#0 // Switch X1/X2
	ADDI	X1,X2,#0
	ADDI    X2,X3,#0
	B       #-8 // Loop... try again
	ST	X2,[X0,#8] // EOJ
	EXIT
