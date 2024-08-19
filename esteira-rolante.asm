;
; Password_keyboard.asm
;
; Created: 10/08/2023 5:47:02 PM
; Author : Daniel Savio
; Qunado eu fiz esse código só duas pessoas sabiam como ele funconava, Deus e eu
; agora, só Deus, boa sorte :)

	.DEF tecla = R17
	.DEF temporizador = R18
	.DEF password = R19
	.DEF tempo_1s = R20
	.DEF check = R21

	.DEF press_time = R22           ; Novo registrador para contar o tempo de pressão da tecla correta
	.DEF new_password_flag = R23    ; Flag para indicar que a nova senha deve ser registrada
	.DEF hash_button = R24          ; Definir o botão `#` como uma constante




	.ORG 0x00
	RJMP start
	.ORG 0x20							; Address of Timer Counter 0 Overflow Interrupt
	RJMP isr_OVF_TC0
start:
	LDI password,5
    LDI R16,$FF
	OUT DDRD,R16
	OUT DDRC,R16
	LDI R16,0b00000111
	OUT DDRB,R16						; Config PB0-PB2 as output and PB3-PB7 as input
	SBI PORTB,PB3
	SBI PORTB,PB4
	SBI PORTB,PB5
	SBI PORTB,PB6
	CLR hash_button              ; Supondo que o botão `#` esteja mapeado como 11
	CLR R16
	OUT PORTC,R16
	OUT MCUCR,R16						; Enable pull-ups inside the uC
	LDI tecla,11
	CLR check
	CLR temporizador
	CLR tempo_1s
	LDI R16,0b00000101
	OUT TCCR0B,R16						; Set prescaler for 1024
	LDI R16,0b00000001
	STS TIMSK0,R16						; Enable Timer Counter 0 Overflow Interrupt
	CLR R16
	OUT TCNT0,R16						; Set Timer Counter 0 Overflow Interrupt register to have 256 increments until overflow
	SEI

loop:
	RCALL read_keyboard
	CPI check,1
	BREQ check_password


return_check:
	CPI tempo_1s,1
	BREQ tic_1s
	RCALL decode
	RJMP loop
tic_1s:
	LDI tempo_1s,0
	CBI PORTC,PC0
	CBI PORTC,PC1
	RJMP loop

decode:
	LDI ZH,HIGH(dec_7seg<<1)
	LDI ZL,LOW(dec_7seg<<1)
	ADD ZL,tecla
	BRCC read_flash
	INC ZH

read_flash:
	LPM R0,Z
	OUT PORTD,R0
	RET

dec_7seg:
	.db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x00, 0x00

read_keyboard:
; Activate column 0
	CBI PORTB,PB0
	SBI PORTB,PB1
	SBI PORTB,PB2
	RJMP check_col_0

; Activate column 1
	col_1:
		SBI PORTB,PB0
		CBI PORTB,PB1
		SBI PORTB,PB2
		RJMP check_col_1

; Activate column 2
	col_2:
		SBI PORTB,PB0
		SBI PORTB,PB1
		CBI PORTB,PB2
		RJMP check_col_2

	check_col_0:
		SBIS PINB,PB3
		LDI tecla,3
		SBIS PINB,PB4
		LDI tecla,6
		SBIS PINB,PB5
		LDI tecla,9
		SBIS PINB,PB6					; When the key is pressed it is low level
		LDI check,1						; When this key is pressed, load 1 in register 'check'
		RJMP col_1

	check_col_1:
		SBIS PINB,PB3
		LDI tecla,2
		SBIS PINB,PB4
		LDI tecla,5
		SBIS PINB,PB5
		LDI tecla,8
		SBIS PINB,PB6
		LDI tecla,0
		RJMP col_2

	check_col_2:
		SBIS PINB,PB3
		LDI tecla,1
		SBIS PINB,PB4
		LDI tecla,4
		SBIS PINB,PB5
		LDI tecla,7
		SBIS PINB,PB6
		LDI hash_button,1
		RET



check_password:
    CLR temporizador
    CLR check
    CP tecla, password
    BREQ check_hash_button         ; Se a senha estiver correta, verifica o botão `#`
    SBI PORTC, PC0
    CBI PORTC, PC1


check_password_change:
    CLR temporizador
    CLR check
    CP tecla, password
    rjmp check_hash_button         ; Se a senha estiver correta, verifica o botão `#`


check_hash_button:

    INC press_time                 ; Incrementa o tempo que o botão `#` é pressionado
    CPI press_time, 5              ; Compara se o tempo chegou a 5 segundos
    BRLO correct_password          ; Se não, continua com a senha correta
    CLR press_time                 ; Reseta o tempo de pressão
    LDI new_password_flag, 1       ; Ativa a flag para registrar a nova senha
    RCALL blink_led                ; Pisca o LED para indicar que pode inserir a nova senha
    RJMP loop

check_hold_time:
		INC press_time                   ; Incrementa o tempo que a tecla correta é pressionada
		CPI press_time,5                 ; Compara se o tempo chegou a 5 segundos
		BRLO correct_password            ; Se não, continua com a senha correta
		CLR press_time                   ; Reseta o tempo de pressão
		LDI new_password_flag,1          ; Ativa a flag para registrar a nova senha
		RCALL blink_led                  ; Pisca o LED para indicar que pode inserir a nova senha
		RJMP return_check

correct_password:
    CBI PORTC, PC0
    SBI PORTC, PC1
    CPI new_password_flag, 1       ; Verifica se a flag de nova senha está ativada
    RJMP return_check              ; Se não, retorna ao loop normal
    MOV password, tecla            ; Registra a nova senha
    CLR new_password_flag          ; Reseta a flag
    RJMP return_check



	blink_led:
		LDI R16,10                       ; Pisca o LED por 10 vezes
	blink_loop:
		SBI PORTC,PC0
		RCALL delay                      ; Chama uma sub-rotina de delay
		CBI PORTC,PC0
		RCALL delay
		DEC R16
		BRNE blink_loop
		RET

	delay:                              ; Sub-rotina de delay simples
		LDI R16,0xFF
	delay_loop:
		NOP
		DEC R16
		BRNE delay_loop
		RET


	isr_OVF_TC0:
		IN R16,SREG						; Stash the content of SREG in R16 register
		CPI temporizador,60				; Compare temporizador with the number 60
		BREQ t_1segundo					; Branch to t_1segundo if the comparison above is true
		INC temporizador				; Increment temporizador until 60
		RJMP fim_interrupt
	t_1segundo:
		CLR temporizador
		LDI tempo_1s,1					; Here the program signs that there have been passed about 1 second
	fim_interrupt:
		OUT SREG,R16					; Return content to SREG
		RETI							; Return from interrupt
