;
; Author : Omphile Matsobe
;

 #define __SFR_OFFSET 0
.Include "M328Pdef.inc"
.Cseg

.Org 0x0000						;Address for reset  
	jmp Main  

.ORG 0x0002						;Address for the external interrupt 0 
	jmp buttonInterruptISR

start:

	ldi R20,HIGH(RAMEND)  
	out SPH,R20  
	ldi R20,LOW(RAMEND)  
	out SPL,R20 		;Set up the stack  

	ldi R20,0x02 		;Trigger INT0 falling edge
	sts EICRA,R20

	ldi R20,0x01		;Enable INT0 - 0b00000001
	out EIMSK,R20		;Enable the external Interrupt Mask
	Sei 				;Enable global interrupt  


	; initializes the USART0 to:
	; 9600 baud, 8 bits, no parity, 1 stop bits
	push	R16
	ldi		R16,00
	sts		ubrr0h,R16 ; use sts instead of out.
	ldi		R16,6 ; ubrr = 6 for a baud rate of 9600
	sts		ubrr0l,R16 ;
	ldi		R16,(1<<txen0)|(1<<rxen0) ;transmit/receive enable
	sts		ucsr0b,r16
	ldi		R16,(1<<usbs0)|(3<<ucsz00) ;8 data
	sts		ucsr0c,r16
	pop		r16
	ret

	sbi		PORTD,2		;Activated pull-up for button
	  
	;;for 7 segment display
	sbi		DDRB,5
	sbi		DDRB,4
	sbi		DDRB,3
	sbi		DDRB,2
	sbi		DDRB,1
	sbi		DDRB,0
	sbi		DDRD,7

loop:
	call	serial_t_r17
	call	serial_r
	jmp loop

;transmits r17 to the serial port via usart0
serial_t_r17:
	push	r16

serial_t1:
	lds		R16,ucsr0a ;wait for empty transmit buffer. 'lds' not 'in'
	sbrs	R16,udre0
	rjmp	serial_t1
	sts		udr0,R17 ;put data in transmit buffer
	pop		R16
	ret

;Reads serial port value into r17
serial_r: ; stops the looping when ucsr0a.rxc0 bit set
	lds		R17,ucsr0a
	andi	R17,0x80 ; 0b10000000, rxc0 (bit 7) = 1 when done
	breq	serial_r
	lds		R17,udr0 ;read usart buffer.
	call	checkreading;
	ret

button_interrupt:
	inc		R16
	reti


call adcInit

checkreading:
    ;checks for which value must be displayed 

         call     adcRead
         call     adcWait
         lds      R18,ADCH ;Read A/D result into r18.

         cpi      R19, 0 ;compares value in R18 with 0
         brlt     checkone
         cpi      R19, 10 ;compares value in R18 with 100
         brge     checkone
         call     zero

checkone:
         cpi      R19, 10 ;compares value in R18 with 0
         brlt     checktwo
         cpi      R19, 20 ;compares value in R18 with 100
         brge     checktwo
         call     one

checktwo:
         cpi      R19, 20 ;compares value in R18 with 0
         brlt     checkthree
         cpi      R19, 30 ;compares value in R18 with 100
         brge     checkthree
         call     two

checkthree:
         cpi      R19, 30 ;compares value in R18 with 0
         brlt     checkfour
         cpi      R19, 40 ;compares value in R18 with 100
         brge     checkfour
         call     three

checkfour:
         cpi      R19, 40 ;compares value in R18 with 0
         brlt     checkfive
         cpi      R19, 50 ;compares value in R18 with 100
         brge     checkfive
         call     four

checkfive:
         cpi      R19, 50 ;compares value in R18 with 0
         brlt     checksix
         cpi      R19, 60 ;compares value in R18 with 100
         brge     checksix
         call     five

checksix:
         cpi      R19, 60 ;compares value in R18 with 0
         brlt     checkseven
         cpi      R19, 70 ;compares value in R18 with 100
         brge     checkseven
         call     six

checkseven:
         cpi      R19, 70 ;compares value in R18 with 0
         brlt     checkeight
         cpi      R19, 80 ;compares value in R18 with 100
         brge     checkeight
         call     seven
         
checkeight:
         cpi      R19, 80 ;compares value in R18 with 0
         brlt     checknine
         cpi      R19, 100 ;compares value in R18 with 100
         brge     checknine
         call     eight

checknine:
         call     nine

zero:  
         cbi      PORTB,0 ;turn port 8 OFF
         sbi      PORTD,7 ;turn port 7 ON
         sbi      PORTD,6 ;turn port 6 ON
         sbi      PORTD,5 ;turn port 5 ON
         sbi      PORTD,4 ;turn port 4 ON
         sbi      PORTD,3 ;turn port 3 ON
         sbi      PORTD,2 ;turn port 2 ON
         jmp      checkreading

one:  
         cbi      PORTB,0 ;turn port 8 OFF
         cbi      PORTD,7 ;turn port 7 OFF
         cbi      PORTD,6 ;turn port 6 OFF
         cbi      PORTD,5 ;turn port 5 OFF
         sbi      PORTD,4 ;turn port 4 ON
         sbi      PORTD,3 ;turn port 3 ON
         cbi      PORTD,2 ;turn port 2 OFF
         jmp      checkreading

two:  
         sbi      PORTB,0 ;turn port 8 ON
         cbi      PORTD,7 ;turn port 7 OFF
         sbi      PORTD,6 ;turn port 6 ON
         sbi      PORTD,5 ;turn port 5 ON
         cbi      PORTD,4 ;turn port 4 OFF
         sbi      PORTD,3 ;turn port 3 ON
         sbi      PORTD,2 ;turn port 2 ON
         jmp      checkreading

three:  
         sbi      PORTB,0 ;turn port 8 ON
         cbi      PORTD,7 ;turn port 7 OFF
         cbi      PORTD,6 ;turn port 6 OFF
         sbi      PORTD,5 ;turn port 5 ON
         sbi      PORTD,4 ;turn port 4 ON
         sbi      PORTD,3 ;turn port 3 ON
         sbi      PORTD,2 ;turn port 2 ON
         jmp      checkreading

four:  
         sbi      PORTB,0 ;turn port 8 ON
         sbi      PORTD,7 ;turn port 7 ON
         cbi      PORTD,6 ;turn port 6 OFF
         cbi      PORTD,5 ;turn port 5 OFF
         sbi      PORTD,4 ;turn port 4 ON
         sbi      PORTD,3 ;turn port 3 ON
         cbi      PORTD,2 ;turn port 2 OFF
         jmp      checkreading

five:  
         sbi      PORTB,0 ;turn port 8 ON
         sbi      PORTD,7 ;turn port 7 ON
         cbi      PORTD,6 ;turn port 6 OFF
         sbi      PORTD,5 ;turn port 5 ON
         sbi      PORTD,4 ;turn port 4 ON
         cbi      PORTD,3 ;turn port 3 OFF
         sbi      PORTD,2 ;turn port 2 ON
         jmp      checkreading
six:  
         sbi      PORTB,0 ;turn port 8 ON
         sbi      PORTD,7 ;turn port 7 ON
         sbi      PORTD,6 ;turn port 6 ON
         sbi      PORTD,5 ;turn port 5 ON
         sbi      PORTD,4 ;turn port 4 ON
         cbi      PORTD,3 ;turn port 3 OFF
         sbi      PORTD,2 ;turn port 2 ON
         jmp      checkreading

seven:  
         cbi      PORTB,0 ;turn port 8 OFF
         cbi      PORTD,7 ;turn port 7 OFF
         cbi      PORTD,6 ;turn port 6 OFF
         cbi      PORTD,5 ;turn port 5 OFF
         sbi      PORTD,4 ;turn port 4 ON
         sbi      PORTD,3 ;turn port 3 ON
         sbi      PORTD,2 ;turn port 2 ON
         jmp      checkreading

eight:  
         sbi      PORTB,0 ;turn port 8 ON
         sbi      PORTD,7 ;turn port 7 ON
         sbi      PORTD,6 ;turn port 6 ON
         sbi      PORTD,5 ;turn port 5 ON
         sbi      PORTD,4 ;turn port 4 ON
         sbi      PORTD,3 ;turn port 3 ON
         sbi      PORTD,2 ;turn port 2 ON
         jmp      checkreading

nine:  
         sbi      PORTB,0 ;turn port 8 ON
         sbi      PORTD,7 ;turn port 7 ON
         cbi      PORTD,6 ;turn port 6 OFF
         sbi      PORTD,5 ;turn port 5 ON
         sbi      PORTD,4 ;turn port 4 ON
         sbi      PORTD,3 ;turn port 3 ON
         sbi      PORTD,2 ;turn port 2 ON
         jmp      checkreading

delay_1ms:
         push     R20
         ldi      R20,100
         ret

adcInit:
    ;Initializes ADC

         ldi      R20, 0b01100000 ;Voltage Reference: AVcc with external capacitor at AREF pin
         sts      ADMUX, R20 ;Enable ADC Left Adjust Result
                          ;Analog Channel: ADC0

         ldi      R20, 0b10000101 ;Enable ADC
         sts      ADCSRA, R16 ;ADC Prescaling Factor: 32
         ret

adcRead:
    ;Reads the ADC value

         ldi      R20, 0b01000000 ;sets the ADSC flag to Trigger ADC Conversion process
         lds      R19, ADCSRA
         or       R19, R20
         sts      ADCSRA, R19
         ret
