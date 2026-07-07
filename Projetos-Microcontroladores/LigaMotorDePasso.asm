;
; AssemblerApplication1.asm
;
; Created: 20/03/2024 19:41:34
; Author : Daniel Savio

; Ligaor motor de passo
.equ first_coil = PC1
.equ second_coil = PC2
.equ third_coil = PC3
.equ fourth_coil = PC4

.equ COIL = PORTC

.ORG 0x00
start:
    LDI R16, 0x00
	LDI R17, 0xFF
	OUT DDRD, R16 ; Define como entrada
	OUT DDRC, R17 ; Define como sa�da

pullup:			;Configura os botoes como pull-up

	SBI PORTD, PD1
	SBI PORTD, PD2
	SBI PORTD, PD3

	OUT MCUCR, R16


clockWiseCheck:
	SBIS PIND, PD1
    RJMP clockWise

clockWise:
   SBI COIL, first_coil
   RCALL wait
   CBI COIL, first_coil

   SBI COIL, second_coil
   RCALL wait
   CBI COIL, second_coil

   SBI COIL, third_coil
   RCALL wait
   CBI COIL, third_coil

   SBI COIL, fourth_coil
   RCALL wait
   CBI COIL, fourth_coil
 

   RJMP clockWiseCheck

wait:
    LDI R16, 0X10
    LDI R17, 0X10
    LDI R18, 0X10
    LDI R19, 0X00
    
wait_delay:
    DEC R16
	BRNE wait_delay
    DEC R17
    BRNE wait_delay
	DEC R18
    BRNE wait_delay
	RET
