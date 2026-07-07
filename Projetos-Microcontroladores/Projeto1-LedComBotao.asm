.ORG 0x00

start:
    LDI R16, 0b00111000
	OUT DDRC, R16

	RJMP pullup

pullup:      ;Configura os botoes como pull-up
	LDI R17, 0X00

	SBI PORTC, PC0
	SBI PORTC, PC1
	SBI PORTC, PC2

	OUT MCUCR, R17
	RJMP code

code:            ; Checa estado do botao 1
SBIC PINC, PC0
	RJMP off1    ; Se botao n pressionado - desliga e vai pro próximo loop
	RJMP on1     ; Se botao pressionado - desliga e vai pro próximo loop


loop1:
SBIC PINC, PC1
	RJMP off2   ; Se botao n pressionado - desliga e vai pro próximo loop
	RJMP on2    ; Se botao pressionado - liga e vai pro próximo loop


loop2:
SBIC PINC, PC2
	RJMP off3  ; Se botao n pressionado - desliga e vai pro próximo loop
	RJMP on3   ; Se botao pressionado - liga e vai pro próximo loop



on1:
	SBI PORTC, PC3
	RJMP loop1

off1:
	CBI PORTC, PC3
	RJMP loop1



on2:
	SBI PORTC, PC4
	RJMP loop2

off2:
	CBI PORTC, PC4
	RJMP loop2

on3:
	SBI PORTC, PC5
	RJMP code

off3:
	CBI PORTC, PC5
	RJMP code
	