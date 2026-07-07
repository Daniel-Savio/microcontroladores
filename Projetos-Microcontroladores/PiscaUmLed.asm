;
; PiscaLeds.asm
;
; Created: 21/02/2024 21:06:03
; Author : Aluno
;


; Esse código pisca o led do PB8 do arduino
.ORG 0X00
start:
    LDI R16, 0XFF
    OUT DDRB, R16

loop:
    SBI PORTB, PB5
    RCALL Delay
    CBI PORTB, PB5
    RCALL Delay
    RJMP Loop

Delay:
    LDI R17,0X00
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

