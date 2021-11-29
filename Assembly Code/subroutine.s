Description: Calls subroutine that retrieves parameter from stack and pops next available parameter.
	     In the case that the stack is empty, R1 will store 0xFFFFFFFF and R0 will store 0x00000001

	AREA mydata, DATA, READWRITE
	ALIGN

	
	AREA ProjectCode, CODE, READONLY
	EXPORT __main
	ALIGN
	ENTRY

__main PROC	
	LDR R4, = 0x20004000 ;address
	MOV SP,R4	     ;define SP
		
	MOV R2, #0xCCCCCCCC  ;param1
	MOV R3, #0xAAAAAAAA  ;param2
	
	push{R2, R3} 	     ;saves parameter into stack
			     ;values of R2 and R3 store
						 
	BL sub1		     ;go into subroutine
	B finish	     ;finish execute
    ENDP
	
	
	
	
		
		

sub1 PROC
	 CMP SP, R4	       ;check to see if address of SP is the same as R4
	 BNE popR	       ;if they are not equal go to popR
						 
	 
			       ;if SP and R4 are equal means the stack is empty
	 MOVEQ R1, #0xFFFFFFFF ;if they are equal, R1 is set to 0xFFFFFFFF
	 MOVEQ R0, #0x00000001 ;if they are equal, R0 is set to 0x00000001
	
	 BX LR		       ;goes to nexxt instruction
	 
	
	
popR
	pop{R1}		       ;retrieve values to R1
	BX LR		       ;goes to next instruction
	ENDP

	
finish
	B finish
	
	
	END
	