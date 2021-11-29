Description: checking if the given matrix is a magic square	
	

	AREA mydata, DATA, READWRITE
	ALIGN
;assuming that these numbers are bytes
array1 DCB  16, 3 , 2 , 13 ;first row
array2 DCB  5, 10 , 11 , 8 ;second row
array3 DCB  9, 6 , 7 , 12  ;thirds row
array4 DCB  4, 15 , 14 ,1  ;fourth row

	
	AREA ProjectCode, CODE, READONLY
	EXPORT __main
	ALIGN
	ENTRY

__main PROC	
	LDR R5, = 0x20004000 ;starting address

	
	LDR R0, = array1  ;load address of array1
	LDR R1, [R0] 	  ;load contents
	LDR R0, = array2  ;load address of array2
	LDR R2, [R0]      ;load contents
	LDR R0, = array3  ;load address of array3
	LDR R3, [R0]      ;load contents
	LDR R0, = array4  ;load address of array4
	LDR R4, [R0]
	
;above was the set up of matrix
;N = 4
;Magic Square = 4(4^2 + 1) / 2 = 34


	MOV R7, #0         ;this will be sum of row
	STR R1,[R5]        ;address will start at 20004000 
	BL row		   ;goes to subroutine to check
	MOV R9, R8 	   ;Load sum value in R9
	
	STR R2,[R5]        ;address will start at 20004004 because loop has increased by 4 bits
	BL row		   ;goes to subroutine to check
	MOV R10, R8	   ;Load sum value in R10
	CMP R9, R10	   ;Compare R9 and R10 to see if first two rows are equal
	BNE NOT 	   ;Branch to NOT if the two rows are not equal
	
	STR R3,[R5]        ;address will start at 20004008 because loop has increased by 4 bits
	BL row	           ;goes to subroutine to check
	MOV R10, R8	   ;can reuse r10 because already compared for efficiency, load sum value in R10
	
	CMP R9, R10        ;Compare first row R9 to this current R10
	BNE NOT		   ;Branch to NOT if the two rows are not equal
	
	STR R4,[R5]        ;address start 2000400C
	BL row		   ;goes to subroutine to check
	MOV R10, R8	   ;R10 can be reused, Load sum in R10
	CMP R9, R10        ;Compare R9 to R10
	BNE NOT		   ;Branch to NOT if the two rows are not equal
	
	                     ;at this point all row should equal 34 
	LDR R5, = 0x20004000 ;reset the address because it has gone to 20004000
	
	BL col		   ;goes to col to check 
	MOV R10, R8	   ;Loads sum of col1 to R10
	ADD R5, R5, #1     ;Add 1 to address so the pointer is at 20004001 pointing at column 2
	CMP R9, R10        ;Compare R9 to R10 to check if equal
	BNE NOT		   ;Branch to NOT if the two rows are not equal
	
	BL col             ;goes to col to check
	MOV R10, R8        ;Loads sum of col2 to R10, R10 reuse since already compared
	ADD R5, R5, #2     ;Add 2 to address so the pointer is at 20004002 pointint at column 3
	CMP R9, R10        ;Compare R9 to R10 to check 
	BNE NOT            ;Branch to NOT if the two rows are not equal
	
	
	BL col		   ;goes to col to check
	MOV R10, R8	   ;Loads sum of col3 to R10, R10 reuse
	ADD R5, R5, #3     ;Add 3 to address so the pointer is at 20004003
	CMP R9, R10        ;Compare R9 and R10
	BNE NOT            ;Branch to NOT if the two rows are not equal
	
	
	BL col             ;goes to col to check
	MOV R10, R8	   ;Loads sum of col4 to R10, R10 reuse
	CMP R9, R10        ;Compare R9 and R10
	BNE NOT            ;Branch to NOT if the two rows are not equal
	
	                   ;at this point all column should be equal to 34
	BL diagonal        ;goes into diagonal to check diagonal sum
	MOV R10, R8        ;Load sum of diagonal to R10, reuse R10
	CMP R9, R10        ;Compare R9 and R10
	BNE NOT            ;Branch to NOT if the two rows are not equal
	
	BL opposite        ;goes into opposite diagonal
	MOV R10, R8        ;Load sum of opposite diagonal, reuse R10
	CMP R9, R10        ;Compare R9 and R10
	BNE NOT            ;Branch to NOT if the two rows are not equal
	
			    ;at this point diagonals should be equal to 34
	MOV R0, #0xFFFFFFFF ;is a magic square so R0 is set to all 1's
	B finish	    ;exit to end or else goes to NOT branch ~ not what we want after R0 is all 1's
	
NOT 
	MOV R0, #0	    ;R0 will be set to 0 because the matrix is not 
	B finish 	    ;exits to end
	
finish
	B finish
					 
	ENDP
		

row PROC
		MOV R6, #4		 ;counter
		MOV R8, #0		 ;clear R8 everytime row is called from main
loop1		LDRB R7, [R5],#1 	 ;Add numbers throughout rows to R7
		ADD R8, R8, R7           ;Add sum to R8
		SUB R6, R6, #1		 ;Decrement counter
		CMP R6,#0		 ;check loop counter
		BNE loop1		 ;exit loop if not equal
		
		CMP R8, #34	         ;Compare if the sum of row1 to actual sum
		MOVNE R0, #0	         ;If R8 is not equal to 34, then R0 set to 0 (clear)
		BX LR					 
		ENDP
			
col PROC
		MOV R6, #4		 ;counter
		MOV R8, #0               ;clear R8 everytime row is called from main
loop2		LDRB R7, [R5], #4	 ;Add column of each array by adding 4 memory spaces in R7
		ADD R8, R8, R7           ;Add sum to R8 
		SUB R6, R6, #1		 ;Decrement counter
		CMP R6,#0		 ;check loop counter
		BNE loop2		 ;exit loop if not equal
		
		CMP R8, #34	         ;Compare if the sum of row1 to actual sum
		MOVNE R0, #0	         ;If R8 is not equal to 34, then R0 set to 0 (clear)
		LDR R5, = 0x20004000     ;reset the address since it is at the last row
		BX LR
		ENDP
			
diagonal PROC
		MOV R6, #4		 ;counter
		MOV R8, #0               ;clear R8 everytime row is called from main
loop3		LDRB R7, [R5], #5	 ;Add column of each array by adding 5 memory spaces in R7
		ADD R8, R8, R7           ;Add sum to R8
		SUB R6, R6, #1		 ;Decrement counter
		CMP R6,#0		 ;check loop counter
		BNE loop3		 ;exit loop if not equal
		
		CMP R8, #34	         ;Compare if the sum of row1 to actual sum
		MOVNE R0, #0	         ;If R8 is not equal to 34, then R0 set to 0 (clear)
		BX LR
		ENDP
		
opposite PROC
		MOV R6, #4		 ;counter
		MOV R8, #0               ;clear R8 everytime row is called from main
		LDR R5, = 0x20004003     ;starts at the last number of array one at address 0x20004003
loop4		LDRB R7, [R5], #3	 ;Add column of each array by adding 3 memory spaces
		ADD R8, R8, R7           ;Add sum to R8 
		SUB R6, R6, #1		 ;Decrement counter
		CMP R6,#0		 ;check loop counter
		BNE loop4		 ;exit loop if not equal
		
		CMP R8, #34	         ;Compare if the sum of row1 to actual sum
		MOVNE R0, #0	         ;If R8 is not equal to 34, then R0 set to 0 (clear)
		BX LR
		ENDP

		

	END
	