// c2f - convert centigrade temp to farenheit
// Centigrade input is in memory at location 4000
MOV X0,#4000
LD X1,[X0,#0] // Load Centigrade temp into X0
MULI X1,X1,#9
DIVI X1,X1,#5 // X1= C*9/5
ADDI X1,X1,#32 // X1 = C*9/5 + 32 
ST X1,[X0,#4]
EXIT
