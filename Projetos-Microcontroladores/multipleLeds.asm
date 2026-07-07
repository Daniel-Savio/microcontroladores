;
; PiscaLeds.asm
;
; Created: 21/02/2024 21:06:03
; Author : Aluno
;


; Esse c�digo pisca diversos leds do ardu�no
; Press F7 to build
; PB0 = Pino 8
; PB1 = Pino 9
; PB2 = Pino 10
.ORG 0X00
start:
    LDI R16, 0XFF
    OUT DDRB, R16

loop:
    SBI PORTB, PB0  ; Set the but 0 of the port B byte as 1 -- Vcc
    SBI PORTB, PB1  ; Set the but 1 of the port B byte as 1 -- Vcc
    SBI PORTB, PB2  ; Set the but 2 of the port B byte as 1 -- Vcc
    RCALL Delay
    CBI PORTB, PB0  ; Set the but 0 of the port B byte as 0 -- GND
    CBI PORTB, PB1  ; Set the but 1 of the port B byte as 0 -- GND
    CBI PORTB, PB2  ; Set the but 2 of the port B byte as 0 -- GND
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

