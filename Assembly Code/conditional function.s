Description: for input y, will compare with each condition given in the assignment and input result into R1 

	AREA mydata, DATA, READWRITE
	ALIGN

	
	
	AREA ProjectCode, CODE, READONLY
	EXPORT __main
	ALIGN
	ENTRY

__main PROC	
	
	LDR R0,= Y     ;assuming y is the input 
	
	 

	;2y 
	CMP R0, #10 ;compare R0 with 10 / firstCond
	BHI secondCond ;if R0 > 10 or will assume that value of R0 is less than 10
	LSL R1, R0, #2 ;this means that the y value of R0 is <= 10 so
				   ;left shift the value in R0 by 2 bits so R1 = 4y / I decided to make LSL shift by 2 bits for consistency throughout the functions
	SUB R1, R1, R0 ;R1 = R1 - R0, 4y-y = 3y
	SUB R1, R1, R0 ;R1 = R1 - R0, 3y-y to make result R1 = 2y
	B finish       ;This section of code is finished, the value for R0 !> 10 then R1 will be set to 2y 
		       ;end
	

	;3y 
secondCond
	CMP R0, #100 ;compare R0 with 100
	BHI thirdCond  ;if R0 > 100, go to label Next2
	LSL R1, R0, #2 ;this means that y value of R0 is > 10 but <= 100
				   ;left shift the value in R0 by 2 bits so R1 = 4y
	SUB R1, R1, R0 ;R1 = R1 - R0, 4y-y to make result R1 = 3y
	B finish       ;This section of code is finished, the value for R0 !> 100 then R1 will be set to 3y 
		       ;end
	
		
	;5y
thirdCond
	CMP R0, #1000
	BHI fourthCond ;if R0 > 1000, go to label Next3
	LSL R1, R0, #2 ;this means y value of R0 is > 100 but <= 1000
				   ;left shift the value in R0 by 2 bits so R1 = 4y
	ADD R1, R1, R0 ;R1 = R1 + R0, 4y +y to make result R1 = 5y
	B finish       ;This section of code is finished, the value for R0 !> 1000 then R1 will be set to 5y 
		       ;end
	

	;6y
fourthCond
	LSL R1, R0, #2 ;left shift the value in R0 by 2 bits so R1 = 4y
	ADD R1, R1, R0 ;R1 = R1 + R0, 4y+ y = 5y
	ADD R1, R1, R0 ;R1 = R1 + R0, 5y + y to make result R1 = 6y
	B finish       ;This section of code is finish, the value for R0 is > than 1000 and R1 will be set to 6y
		       ;end


	
	
finish 
	B finish 

	ENDP 



