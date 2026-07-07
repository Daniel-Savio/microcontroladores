;Extensao do VSCode para AVR = AVR Support

; A ideia é ligar o motor de passo no sentido horário e antihorário podendo controlar o passo completo ou meio passo com um botao para parar


; Created: 20/03/2024 19:41:34
; Author : Daniel Savio

; Definição das variaveis que apontam para cada bobina do motor
.equ first_coil = PC1 
.equ second_coil = PC2
.equ third_coil = PC3
.equ fourth_coil = PC4

; Registrador das saídas
.equ COIL = PORTC

;
.ORG 0x00


;Funcoes de configuracao
start:
    LDI R16, 0x00
	LDI R17, 0xFF
	OUT DDRD, R16 ; Define como entrada
	OUT DDRC, R17 ; Define como saida

pullup:		;Configura os botoes como pull-up

	SBI PORTD, PD1
	SBI PORTD, PD2
	SBI PORTD, PD3
	SBI PORTD, PD4

	OUT MCUCR, R16



;Funcoes de logica
default:
; Escreve 0 em todos os pinos de saída
    CBI COIL, fourth_coil
    CBI COIL, third_coil
    CBI COIL, second_coil
    CBI COIL, first_coil

buttonCheck:
    ; Se o botao for pressionado, vai para `checkStepClockWise` caso contrário pula a linha abaixo e segue o código
	SBIS PIND, PD1
    RJMP checkStepClockWise

    ; Se o botao for pressionado, vai para `checkStepCounterClockWise` caso contrário pula a linha abaixo e segue o código
	SBIS PIND, PD2
    RJMP checkStepCounterClockWise

    ; Se o botao for pressionado, vai para `default` que desliga o motor
	SBIS PIND, PD3
    RJMP default

    RJMP default

checkStepClockWise:
    ; Se o botao for pressionado, vai para `default` que desliga o motor
	SBIS PIND, PD3
    RJMP default

    SBIC PIND, PD4
    RJMP clockWise

    RJMP halfClockWise

checkStepCounterClockWise:
    ; Se o botao for pressionado, vai para `default` que desliga o motor
    SBIS PIND, PD3
    RJMP default


    SBIC PIND, PD4
    RJMP counterClockWise

    RJMP halfCounterClockWise




;Funcoes que ligam o motor
clockWise:
    ; Se o botao for pressionado, vai para `default` que desliga o motor
	SBIS PIND, PD3
    RJMP default

   SBI COIL, fourth_coil
   RCALL wait
   CBI COIL, fourth_coil

   SBI COIL, third_coil
   RCALL wait
   CBI COIL, third_coil

   SBI COIL, second_coil
   RCALL wait
   CBI COIL, second_coil

   SBI COIL, first_coil
   RCALL wait
   CBI COIL, first_coil

   RJMP checkStepClockWise

counterClockWise:
    ; Se o botao for pressionado, vai para `default` que desliga o motor
    SBIS PIND, PD3
    RJMP default

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
 

   RJMP checkStepCounterClockWise

halfClockWise:
	; Se o botao for pressionado, vai para `default` que desliga o motor
    SBIS PIND, PD3
    RJMP default


   SBI COIL, fourth_coil
   RCALL wait
   CBI COIL, first_coil
   RCALL wait

   SBI COIL, third_coil
   RCALL wait
   CBI COIL, fourth_coil
   RCALL wait


   SBI COIL, second_coil
   RCALL wait
   CBI COIL, third_coil
   RCALL wait

   SBI COIL, first_coil
   RCALL wait
   CBI COIL, second_coil
   RCALL wait




   RJMP checkStepClockWise

halfCounterClockWise:
	; Se o botao for pressionado, vai para `default` que desliga o motor
    SBIS PIND, PD3
    RJMP default


   SBI COIL, first_coil
   RCALL wait
   CBI COIL, fourth_coil
   RCALL wait

   SBI COIL, second_coil
   RCALL wait
   CBI COIL, first_coil
   RCALL wait


   SBI COIL, third_coil
   RCALL wait
   CBI COIL, second_coil
   RCALL wait

   SBI COIL, fourth_coil
   RCALL wait
   CBI COIL, third_coil
   RCALL wait



   RJMP checkStepCounterClockWise







wait:
    LDI R16, 0X50
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
