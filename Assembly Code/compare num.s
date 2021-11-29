Description: compare num1 and num2; if(num1< num2) set R0 =1 else R0 = -1

	AREA mydata, DATA, READWRITE
	ALIGN
num1   	DCD   2567
num2   	DCD   500	
	
	
	AREA ProjectCode, CODE, READONLY
	EXPORT __main
	ALIGN
	ENTRY
	
__main PROC	
	
	 LDR R3,=num1 ;loading the address of num1 to R3
      	 LDR R4,=num2 ;loading the address of num2 to R3
		      ;since these two last call only load the address we need to load the contents into another register
	 LDR R1,[R3]  ;loads value in address R3 to R1
	 LDR R2,[R4]  ;loads value in address R4 to R2
	  

	  ;I decided not to use branches because we lose 
	  CMP R1, R2   ;Compare R1 and R2
	  MOVLO R0,#1  ;if R1 < R2 execute call and set R0 to #1  / output = 0x00000001
				   ;otherwise
	  MOVHS R0,#-1 ;if R1 > R2 execute call and set R0 to #-1 / output = 0xFFFFFFFF
				   ;end

	
finish 
	B finish 

	ENDP 

