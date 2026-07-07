;
; AssemblerApplication1.asm
;
; Created: 10/07/2024 21:00:27
; Author : Daniel Savio

; Display em catodo comum, logo acende em 1
; R16 = Meu registrador auxiliar 1
; DDRC = Controle do display
; DDRD = saida dos leds do display

	.ORG	0x00			;inicio do cod

	;Alocacao de memoria RAM
	.org 0x100				;A alocacao da RAM vai comecar no primeiro espaco de memoria disponivel
	.dseg					;Inicio de alocacao de dados
	display: .byte 10		;Aloca 10 bytes na memoria RAM
	
	.cseg					;Starta o codigo

	.DEF dezena = R17		;Define meu registrador R17 como a minha dezena
	.DEF unidade = R18		;Define meu registrador R18 como a minha unidade

	
start:
	LDI	R16, 0xFF 			;carrega 255 em R16
	OUT	DDRD, R16 			;configura DDRD como saida para o display de 7seg
	
	LDI R16, 0x00			;zera o R16
	OUT PORTD, R16			;configura o PORTD para desligar o display

	LDI R16, 0xFF			;tudo em 1
	OUT DDRC, R16			;configura o controle do display Mux

	LDI dezena, 1			;Setta a dezena como 1
	LDI unidade, 2			;Setta a unidade como 2

	LDI R16, 0b00111111		; = Display em 0
	STS display, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the first space in memory
	
	LDI R16, 0b00000110		; = Dsiplay em 1
	STS display+1, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 1
	
	LDI R16, 0b01011011		; = Dsiplay em 2
	STS display+2, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 2
	
	LDI R16, 0b01001111		; = Dsiplay em 3
	STS display+3, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 3
	
	LDI R16, 0b01100110		; = Dsiplay em 4
	STS display+4, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 4
	
	LDI R16, 0b01100110		; = Dsiplay em 5
	STS display+5, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 5
	
	LDI R16, 0b01111100		; = Dsiplay em 6
	STS display+6, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 6
	
	LDI R16, 0b00000111		; = Dsiplay em 7
	STS display+7, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 7

	LDI R16, 0b01111111		; = Dsiplay em 8
	STS display+8, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 8

	LDI R16, 0b01100111		; = Dsiplay em 9
	STS display+9, R16		;STS = Set direct to data space, it works like the OUT but for RAM memory, in the firts space in  memory + 8

loop:
	RCALL mux
	RJMP loop

mux:
	;Display Unidade
	;Mostra unidade
	CBI		PORTC,PC1		;Joga 0 no meu controle de dezena
	LDI		ZH,0x01			;trabalhando com ponteiros na memoria de parte alta
	LDI		ZL,0x00			;trabalhando com ponteiros na memoria de parte baixa

	; my register z = 0x100, whre my RAM alocated memory starts
	ADD		ZL,unidade		; apontando para a posicao da memoria RAM inicial + valor guardado em "unidade"	
	LD		R0,Z			; coloco o valor de Z em R0
	OUT		PORTD,R0		; externalizo isso para meu PORTD
	SBI		PORTC,PC0
	RCALL	delay

	;Mostra dezena
	CBI		PORTC,PC0		;Joga 0 no meu controle de unidade
	LDI		ZH,0x01
	LDI		ZL,0x00
	ADD		ZL,dezena
	LD		R0,Z
	OUT		PORTD,R0
	SBI		PORTC,PC0
	RCALL	delay
	RJMP	loop


delay:
	CLR		R21
	CLR		R22
wait:
	DEC		R21
	BRNE	wait
	DEC		R22



	