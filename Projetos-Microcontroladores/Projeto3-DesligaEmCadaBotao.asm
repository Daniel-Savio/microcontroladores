.ORG 0x00

; Botao1 = PB1
; Botao2 = PB2

;LED = PC0
.ORG 0x00
start:
    LDI R16, 0x00
	LDI R17, 0xFF
	OUT DDRB, R16
	OUT DDRC, R17

	RJMP pullup

pullup:				;Configura os botoes como pull-up
	LDI R18, 0x00

	SBI PORTB, PB1
	SBI PORTB, PB2

	OUT MCUCR, R18
	RJMP code

code:
SBIC PINB, PB1
	RJMP desligaLed
	RJMP ligaLed 


ligaLed:
	SBI PORTC, PC0
	RJMP code

desligaLed:
	CBI PORTC, PC0
	RJMP code