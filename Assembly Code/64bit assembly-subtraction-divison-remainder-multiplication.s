Description: 64bit subtraction, divison, remainder, and multiplication 

(in the ___mainPROC)
;#1
		;A = 00000000FFFFFFFF
		LDR R0, =  0xFFFFFFFF 
		LDR R1, =  0x00000000
		
		;B = 0000000300000004
		LDR R2, =  0x00000003
		LDR R3, =  0x00000004
		
		;C = A - B
		;takes two 64 bit and subtracts

		SUBS R4, R0, R2 ;will subtract lower part R0-R2(31...0) A-B, and also update carry (borrow)
		SBC  R5, R1, R3 ;will subtract upper part R1-R3(64...32) A-B minus carry 



;#2
		; replace bit 4 with bit 15 at R2 and load to register R3
		BFI R3, R2, #4, #12



;#3
		;find division
		LDR R4, = 0x0B ;11
		LDR R5, = 0x02 ;2
		
		SDIV R6, R4, R5 ;divison = 5
		MLS  R7, R5, R6, R4 ; R7 = 11-(2x5) is the remainder


FOR 4 and 5
		;assuming R6 and R& are loaded
		LDR R6, = 0x80000001
		LDR R7, = 2
;#4
		;unsigned
		UMULL R8, R9, R6, R7 ; unsigned multi of R6 and R7 loaded to R8 and R9 because 32bit x 32 bit = 64bit
							 ; two registers are required to store


;#5
		;signed
		SMULL R10, R6, R7   ;signed multiplicaiton of R6 and R7




