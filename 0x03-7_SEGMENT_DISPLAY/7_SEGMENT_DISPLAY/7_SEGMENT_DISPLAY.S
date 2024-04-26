; Created: 2024/04/23 17:14:23
; Author : Omphile matsobe
;
;;; Allow us to use names like "PORTB" && "PORTD" for ports

#define __SFR_OFFSET 0  
#include   "avr/io.h"

.global main


main:

         sbi      DDRB,0 ;set port 8 as output
         sbi      DDRD,7 ;set port 7 as output
         sbi      DDRD,6 ;set port 6 as output
         sbi      DDRD,5 ;set port 5 as output
         sbi      DDRD,4 ;set port 4 as output
         sbi      DDRD,3 ;set port 3 as output
         sbi      DDRD,2 ;set port 2 as output

         ldi      R18,0x3f ;digital input disable.
         sts      DIDR0,R18
         ldi      R18,0x20 ;8 bits, select channel 0
         sts      ADMUX,R18
         ldi      R18,0xe0 ;continuously update adch
         sts      ADCSRA,R18

call adcInit

checkreading:
    ;checks for which value must be displayed 

         call     adcRead
         call     adcWait
         lds      R18,ADCH ;Read A/D result into r18.

         cpi      R18, 0 ;compares value in R18 with 0
         brlt     checkone
         cpi      R18, 10 ;compares value in R18 with 100
         brge     checkone
         call     zero

checkone:
         cpi      R18, 10 ;compares value in R18 with 0
         brlt     checktwo
         cpi      R18, 20 ;compares value in R18 with 100
         brge     checktwo
         call     one

checktwo:
         cpi      R18, 20 ;compares value in R18 with 0
         brlt     checkthree
         cpi      R18, 30 ;compares value in R18 with 100
         brge     checkthree
         call     two

checkthree:
         cpi      R18, 30 ;compares value in R18 with 0
         brlt     checkfour
         cpi      R18, 40 ;compares value in R18 with 100
         brge     checkfour
         call     three

checkfour:
         cpi      R18, 40 ;compares value in R18 with 0
         brlt     checkfive
         cpi      R18, 50 ;compares value in R18 with 100
         brge     checkfive
         call     four

checkfive:
         cpi      R18, 50 ;compares value in R18 with 0
         brlt     checksix
         cpi      R18, 60 ;compares value in R18 with 100
         brge     checksix
         call     five

checksix:
         cpi      R18, 60 ;compares value in R18 with 0
         brlt     checkseven
         cpi      R18, 70 ;compares value in R18 with 100
         brge     checkseven
         call     six

checkseven:
         cpi      R18, 70 ;compares value in R18 with 0
         brlt     checkeight
         cpi      R18, 80 ;compares value in R18 with 100
         brge     checkeight
         call     seven
         
checkeight:
         cpi      R18, 80 ;compares value in R18 with 0
         brlt     checknine
         cpi      R18, 100 ;compares value in R18 with 100
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
         push     R16
         ldi      R16,100
         ret

adcInit:
    ;Initializes ADC

         ldi      R16, 0b01100000 ;Voltage Reference: AVcc with external capacitor at AREF pin
         sts      ADMUX, R16 ;Enable ADC Left Adjust Result
                          ;Analog Channel: ADC0

         ldi      R16, 0b10000101 ;Enable ADC
         sts      ADCSRA, r16 ;ADC Prescaling Factor: 32
         ret

adcRead:
    ;Reads the ADC value

         ldi      R16, 0b01000000 ;sets the ADSC flag to Trigger ADC Conversion process
         lds      r17, ADCSRA
         or       r17, r16
         sts      ADCSRA, r17
         ret

adcWait:
    ;Allows more time to read the value

         lds      r17, ADCSRA ;Observe the ADIF flag, it gets set by hardware when ADC conversion completes
         sbrs     r17, 4
         jmp      adcWait ;Keep checking until the flag is set by hardware
         ldi      r16, 0b00010000 ;set the flag again to signal 'ready-to-be-cleared' by hardware
         lds r17, ADCSRA       
         or  r17, r16          
         sts  ADCSRA, r17      
         ret