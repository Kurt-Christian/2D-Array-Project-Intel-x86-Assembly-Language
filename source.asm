;@author Kurt Krenz

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data
array WORD 16 DUP (?)
numberInput BYTE 1d
largestNumber WORD 0
largestNumberString BYTE ?
largestNumberOfDigits BYTE 0
rowToSum BYTE ?
sum DWORD ?
columnToSum BYTE ?
numbersGreaterThan100 BYTE ?
tempStorage0 WORD 0
tempStorage1 WORD 0
charInput BYTE ?

INCLUDE Macros.inc
INCLUDE Irvine32.inc
.code
main PROC
	CALL WelcomeText
	CALL GetInput
	CALL OutPut
	CALL SumRow
	CALL SumColumn
	CALL FindGreaterThan100
	CALL ChangeRows
	INVOKE ExitProcess, 0				;exit process


WelcomeText PROC
	MWRITE "Please enter 16 numbers of WORD size (up to 200):"
	CALL CRLF
	RET
	WelcomeText ENDP

	;  Putting numbers from user into array just as a normal 
	;  one-dimensional array, but will access it like a two-dimensional array
GetInput PROC
	MOV ESI, 0d												;will increment by 2d bc two bytes in WORD
	MOV ECX, LENGTHOF array
loop0:
	MWRITE "Number: "
	MOV EAX, 0
	MOV AL,   numberInput
	INC numberInput
	CALL WriteDec
	CALL CRLF
	CALL ReadInt	
	.IF AX > 200											;error checking for if input is greater than 200d
		MWRITE "Input must be equal to or less than 200, try again!"
		CALL CRLF
		INC ECX
		DEC numberInput
		LOOP loop0
	.ENDIF
	MOV array[ESI], AX	
	.IF AX > largestNumber									;code for selecting the largest number input by user
		MOV largestNumber, AX								;will later be used for formatting output text
	.ENDIF													;
	ADD ESI, 2d
	LOOP loop0
	RET 
	GetInput ENDP
	
	;outputs the 4X4 matric of user input
OutPut PROC
	CALL CRLF
	CALL CRLF
	MOV ECX, LENGTHOF array /4d					;divided by 4d bc of 4 rows
	MOV ESI, 0
loop0:
	PUSH ECX
	MOV ECX, LENGTHOF array /4d					;divided by 4d bc of 4d numbers per row
loop1:
	MOV EAX, 0
	MOV AX, array[ESI]
	.IF AX < 10d
		MWRITE "  "								;2 spaces before printing number
		CALL WriteDec
		ADD ESI, 2d
	.ELSEIF AX < 100d
		MWRITE " "								;1 space before printing number
		CALL WriteDec
		ADD ESI, 2d
	.ELSEIF AX < 201d
		CALL WriteDec							;0 space berfore printing number
		ADD ESI, 2d
	.ENDIF
		MWRITE "   "
		LOOP loop1
	POP ECX
	CALL CRLF
	CALL CRLF
			LOOP loop0
	RET 
	OutPut ENDP

	;sums the row given by the user
SumRow PROC
	MOV EBX, OFFSET array
	MOV ESI, 0
	CALL CRLF
loopInput:
	MWRITE "Please input the row number which you would like to sum [1,4]: "
	MOV EAX, 0
	CALL ReadInt
	MOV rowToSum, AL
	.IF rowToSum > 4
	MWRITE "Invalid input, must be 4 or less"
	CALL CRLF
	LOOP loopInput
	.ENDIF
	MOV EAX, 0
	.IF rowToSum == 1d
		ADD EBX, 0d
		MOV ECX, 4d
loop1:
		ADD AX, [EBX + ESI]
		ADD ESI, 2d
		LOOP loop1
		MOV sum, EAX
	.ELSEIF rowToSum == 2d
		ADD EBX, 8d
		MOV ECX, 4d
loop2:
		ADD AX, [EBX + ESI] 
		ADD ESI, 2d
		LOOP loop2
		MOV sum, EAX
	.ELSEIF rowToSum == 3d
		ADD EBX, 16d
		MOV ECX, 4d
loop3:
		ADD AX, [EBX + ESI]
		ADD ESI, 2d
		LOOP loop3
		MOV sum, EAX
	.ELSEIF rowToSum == 4d
		ADD EBX, 24d
		MOV ECX, 4d
loop4:
		ADD AX, [EBX + ESI]
		ADD ESI, 2d
		LOOP loop4
		MOV sum, EAX
	.ENDIF
	MWRITE "The sum of row number "
	MOV EAX, 0
	MOV AL, rowToSum
	CALL WriteDec
	MWRITE " is: "
	MOV EAX, sum
	CALL WriteDec
	CALL CRLF
	CALL CRLF
	RET
	SumRow ENDP

SumColumn PROC
	MOV sum, 0
	MOV EBX, OFFSET array
	MOV ESI, 0
	CALL CRLF
loopInput:
	MWRITE "Please input the column number which you would like to sum [1,4]: "
	MOV EAX, 0
	CALL ReadInt
	MOV columnToSum, AL
	.IF columnToSum > 4
	MWRITE "Invalid input, must be 4 or less"
	CALL CRLF
	LOOP loopInput
	.ENDIF
	MOV EAX, 0
	.IF columnToSum == 1d
		ADD EBX, 0d
		MOV ECX, 4d
loop1:
		ADD AX, [EBX + ESI]
		ADD EBX, 8d
		LOOP loop1
		MOV sum, EAX
	.ELSEIF columnToSum == 2d
		ADD EBX, 0
		MOV ECX, 4d
		MOV ESI, 2d
loop2:
		ADD AX, [EBX + ESI] 
		ADD ESI, 8d
		LOOP loop2
		MOV sum, EAX
	.ELSEIF columnToSum == 3d
		ADD EBX, 0d
		MOV ECX, 4d
		MOV ESI, 4d
loop3:
		ADD AX, [EBX + ESI]
		ADD EBX, 8d
		LOOP loop3
		MOV sum, EAX
	.ELSEIF columnToSum == 4d
		ADD EBX, 0
		MOV ECX, 4d
		MOV ESI, 6d
loop4:
		ADD AX, [EBX + ESI]
		ADD EBX, 8d
		LOOP loop4
		MOV sum, EAX
	.ENDIF
	MWRITE "The sum of column number "
	MOV EAX, 0
	MOV AL, columnToSum
	CALL WriteDec
	MWRITE " is: "
	MOV EAX, sum
	CALL WriteDec
	CALL CRLF
	CALL CRLF
	RET
	SumColumn ENDP

FindGreaterThan100 PROC
	MOV ECX, LENGTHOF array
	MOV EAX, 0
	MOV EBX, OFFSET array
	MOV ESI, 0
loop0:
	MOV AX, [EBX + ESI]
	.IF AX > 100d
		INC numbersGreaterThan100
	.ENDIF
	ADD ESI, 2d
	LOOP loop0

	MWRITE "There were "
	MOV AL, numbersGreaterThan100
	CALL WriteDec
	MWRITE " numbers greater than 100."
	CALL CRLF
	CALL CRLF
	RET
	FindGreaterThan100 ENDP

ChangeRows PROC
waitForReady:
	MWRITE "Are you ready to switch rows number 1 and 3? (Y/N): "
	CALL READCHAR
	MOV charInput, AL
	.IF charInput == "Y"
		JMP ready
	.ELSE
		CALL CRLF
		LOOP waitForReady
	.ENDIF
ready:
	CALL CRLF 
	CALL CRLF
	MWRITE "Rows number 1 and 3 will now be switched:"
	CALL CRLF 
	CALL CRLF
	MWRITE "Here is the original matrix:"
	CALL CRLF
	CALL CRLF
	CALL OutPut
	CALL CRLF
	CALL CRLF
	CALL CRLF
	MWRITE "And here is the matrix after being switched:"
	CALL CRLF
	CALL CRLF

	MOV ECX, LENGTHOF array /4d
	MOV EDI, OFFSET array				;EDI will serve just at the EBX has served prior to this in the program, holding the offset of the array
	MOV ESI, 0
loop0:
	MOV EAX, 0
	MOV AX, [EDI + ESI]
	MOV tempStorage0, AX
	PUSH EDI
	ADD EDI, 16d
	MOV EAX, 0
	MOV AX, [EDI + ESI]
	MOV tempStorage1, AX
	MOV AX, tempStorage0
	MOV [EDI + ESI], AX
	POP EDI
	MOV AX, tempStorage1
	MOV [EDI + ESI], AX
	ADD ESI, 2d
	LOOP loop0
	CALL OutPut
	MWRITE "Program teminating..."

	RET 
	ChangeRows ENDP

	main ENDP							
END main								

