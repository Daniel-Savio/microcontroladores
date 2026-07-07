;
; PiscaLeds.asm
;
; Created: 21/02/2024 21:06:03
; Author : Aluno
;


; Esse código pisca um led de cada vez e o mantem aceso
; Press F7 to build
; PD0 = Pino 0
; PD1 = Pino 1
; PD2 = Pino 2
; PD3 = Pino 3
; PD4 = Pino 4
; PD5 = Pino 5
; PD6 = Pino 6
; PD7 = Pino 7
.ORG 0X00
start:
    LDI R16, 0Xff
    OUT DDRD, R16

loop:
  
	LDI PORTD, 0X00
    ;   Liga e espera um pouco    
    SBI PORTD, PD0  
    RCALL Delay

    ;   Liga e espera um pouco    
    SBI PORTD, PD1  
    RCALL Delay

    ;   Liga e espera um pouco    
    SBI PORTD, PD2  
    RCALL Delay

    ;   Liga e espera um pouco    
    SBI PORTD, PD3  
    RCALL Delay

    ;   Liga e espera um pouco    
    SBI PORTD, PD4
    RCALL Delay

    ;   Liga e espera um pouco    
    SBI PORTD, PD5
    RCALL Delay

    ;   Liga e espera um pouco    
    SBI PORTD, PD6
    RCALL Delay

    ;   Liga e espera um pouco    
    SBI PORTD, PD7
    RCALL Delay


    RJMP Loop

Delay:
    LDI R17, 0X00
    LDI R18, 0X00
    LDI R19, 0X50

Wait:
    DEC R17
    BRNE Wait
    DEC R18
    BRNE Wait
    DEC R19
    BRNE Wait
    RET

