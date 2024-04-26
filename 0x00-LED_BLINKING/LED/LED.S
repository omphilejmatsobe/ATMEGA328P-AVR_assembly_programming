; Author : Omphile matsobe
;
;;; Allow me to use names like "PORTB"

#define __SFR_OFFSET 0	
#include   "avr/io.h"

start:
         SBI      DDRB,5

blink:  
         LDI      R20,250
         CALL     delay_n_ms
         SBI      PORTB,5
         LDI      R20,250
         CALL     delay_n_ms                                                                                                                                                                                                                                                                                                                                                                                                            
         CBI      PORTB,5
         JMP      blink

delay_n_ms:
;;; Delay about r20*1ms.  Destroys r20, r30, and r31.
;;; One millisecond is about 16000 cycles at 16MHz.
;;; The basic loop takes about 5 cycles, so we need about 3000 loops.

	       ldi      31, 3000>>8		; high(3000)
	       ldi      30, 3000&255	; low(3000)
  
delaylp:
	       sbiw     R30, 1
	       brne     delaylp
	       subi     R20, 1
	       brne     delay_n_ms
	       ret