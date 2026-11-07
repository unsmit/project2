// LEGv8 Routine to calculate the prime factors of an integer a
// Puts the factors in array R
// Algorithm: 
//      fact=2;i=0;
//	while(fact<(a/2)) {
//		if (0==a%b) {
//                 R[i]=fact; 
//                 i++;
//                 a=a/fact;
//		}
//		else fact++;
//	}
//      R[i]=a;
//      
// Register Usage: X8->R[i], X0=a, X1=fact, 
	MOV	X8,#4000
	LD	X0,[X8,#0]	// First word is the "A" value
	MOV	X1,#2		// Initialize fact=2
	DIVI    X4,X0,#2	// LOOP: X4=a/2
	SUB     X9,X4,X1 	// X9=a/2-fact and set flags
	CBNEG	X9,#11		// If (a/2<fact) goto ELOOP
	DIV	X4,X0,X1	// X4=a/b
	MUL	X5,X4,X1        // X5=(a/b)*b   
	SUB	X4,X0,X5	// X4=a-(a/b)*b Sets X4 to 0 if a divides b
	CBNZ	X4,#5		// If X4 is !0, factor does not divide
	ADDI	X8,X8,#4	// Add 4 to mem ptr
	ST	X1,[X8,#0]	// Store fact at X8
	DIV	X0,X0,X1	// a = a/fact
	B	#-10		// branch to loop
	ADDI	X1,X1,#1	// NDIV: Increment fact
	B	#-12		// Loop back for next factor
	ADDI	X8,X8,#4	// ELOOP: Make room for the last factor
	ST	X0,[X8,#0]	// Store A as the last factor
	EXIT			// End of program
	//   #444 // 444=2*222=2*2*111=2*2*3*37	       
