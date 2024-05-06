; Cyclone
; Created: 2024/05/06 16:37:11
; Author : omphile matsobe


 #define __SFR_OFFSET 0
.Include "M328Pdef.inc"
.Equ Value = 0xE17B ;Timing value to give 1sec
.Cseg

.Org 0x0000						;Address for reset  
	jmp Main  

.ORG 0x0002						;Address for the external interrupt 0 
	jmp Main  
	jmp buttonInterruptISR

rounds:
			clr   R3 ; Initialize var i to 0

light_index:
			clr   R4;   Initialize var i to 0

random:
			clr   R5; Initialize var i to 0

score:
			clr   R6; Initialize var i to 0

start_light:
			clr	  R7; Initialize var i to 0

inti:
			ldi	  R22,2
			ldi	  R23,4
			ldi	  R24,5

;;Main program. Initializes Interrupt, allows required ports
;;Manages Round count stores in R3
;;Manages the random select 
Main:		
			ldi R20,HIGH(RAMEND)  
			out SPH,R20  
			ldi R20,LOW(RAMEND)  
			out SPL,R20 		;Set up the stack  

			ldi R20,0x02 		;Trigger INT0 falling edge
			sts EICRA,R20

			ldi R20,0x01		;Enable INT0 - 0b00000001
			out EIMSK,R20		;Enable the external Interrupt Mask
			Sei 				;Enable global interrupt  

			sbi PORTD,2		;Activated pull-up  
			sbi DDRB,5
			sbi DDRB,4
			sbi DDRB,3
			sbi DDRB,2
			sbi DDRB,1
			sbi DDRB,0
			sbi DDRD,7
			sbi DDRD,6
			sbi DDRD,5
			sbi DDRD,4
			sbi DDRD,3
			sbi DDRD,1
			sbi DDRD,0

			cbi PORTB,5
			cbi PORTB,4
			cbi PORTB,3
			cbi PORTB,2
			cbi PORTB,1
			cbi PORTB,0
			cbi PORTD,7
			cbi PORTD,6
			cbi PORTD,5
			cbi PORTD,4
			cbi PORTD,3
			cbi PORTD,1
			cbi PORTD,0

			ldi R17,0xFF
			out DDRB,R17
			
			rjmp check

//Toggle all the lights in a sequence
lights:		
			clr R5
			clr R4
			
			inc R5
			cbi PORTD,4
			sbi PORTB,5
			call timer;
			inc R4

			inc R5
			sbi PORTB,4
			cbi PORTB,5
			call timer;
			inc	R4

			inc R5
			sbi PORTB,3
			cbi PORTB,4
			call timer
			inc R4

			inc R5
			sbi PORTB,2
			cbi PORTB,3
			call timer;
			inc	R4

			inc R5
			sbi PORTB,1
			cbi PORTB,2
			call timer;
			inc R4

			inc R5
			sbi PORTB,0
			cbi PORTB,1
			call timer;
			inc R4

			inc R5
			sbi PORTD,7
			cbi PORTB,0
			call timer;
			inc R4

			inc R5
			sbi PORTD,6
			cbi PORTD,7
			call timer;
			inc R4

			inc R5
			sbi PORTD,5
			cbi PORTD,6
			call timer;
			inc R4

			inc R5
			sbi PORTD,4
			cbi PORTD,5
			call timer;
			inc R4

			inc R5
			jmp lights 

buttonInterruptISR:	
			sbi PORTB,2	;Display PORTB.2
			cp R4,R7
			brne inc_score;increases the score if round is correct
			inc R3 ;increments number of rounds
			reti

timer:						;1 sec timer counter using Timer1
			ldi R30, High(Value)
			sts TCNT1H, R30
			ldi R30, Low(Value)
			sts TCNT1L, R30		;Sets up the timer counter

			ldi R31, 0x00		;0b00000000 - normal mode
			sts TCCR1A, R31
			ldi R31, 0x05		;0b00000101, prescaler = 1024 
			sts TCCR1B, R31		;Enables the timer counter

Loop: 	
			sbis TIFR1, TOV1	;If TOV1=1, skip next instruction
			rjmp Loop			;else, loop back and check TOV1 flag

			sbi TIFR1, TOV1		;Clear TOV1 bit by writing a 1 to it

			ldi R30, 0xFF		;0b11111111
			sts TCCR1B, R30		;Stop timer1
			ret

show_score:
			cp	R6,R22
			brlo light_red
			cp	R6,R23
			brlo light_blue
			cp	R6,R23
			brne light_green

light_red:
			cbi	PORTD,3
			call timer
			jmp stop

light_blue:
			cbi	PORTD,1
			call timer
			jmp stop

light_green:
			cbi	PORTD,0
			call timer
			jmp stop

inc_score:
			inc	R6
			ret
		
check:
			cp R3,R24
			brsh stop
			ret
;;clears everything and pauses the game
stop:
			call show_score
			call timer
			call timer
			clr R3
			clr R4
			clr R5
			clr R6
			clr R7
			cbi PORTB,5
			cbi PORTB,4
			cbi PORTB,3
			cbi PORTB,2
			cbi PORTB,1
			cbi PORTB,0
			cbi PORTD,7
			cbi PORTD,6
			cbi PORTD,5
			cbi PORTD,4
			cbi PORTD,3
			cbi PORTD,1
			cbi PORTD,0