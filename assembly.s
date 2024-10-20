/*
 * assembly.s
 *
 */
 
 @ DO NOT EDIT
	.syntax unified
    .text
    .global ASM_Main
    .thumb_func

@ DO NOT EDIT
vectors:
	.word 0x20002000
	.word ASM_Main + 1

@ DO NOT EDIT label ASM_Main
ASM_Main:

	@ Some code is given below for you to start with
	LDR R0, RCC_BASE  		@ Enable clock for GPIOA and B by setting bit 17 and 18 in RCC_AHBENR
	LDR R1, [R0, #0x14]
	LDR R2, AHBENR_GPIOAB	@ AHBENR_GPIOAB is defined under LITERALS at the end of the code
	ORRS R1, R1, R2
	STR R1, [R0, #0x14]

	LDR R0, GPIOA_BASE		@ Enable pull-up resistors for pushbuttons
	MOVS R1, #0b01010101
	STR R1, [R0, #0x0C]
	LDR R1, GPIOB_BASE  	@ Set pins connected to LEDs to outputs
	LDR R2, MODER_OUTPUT
	STR R2, [R1, #0]
	MOVS R2, #0         	@ NOTE: R2 will be dedicated to holding the value on the LEDs

@ TODO: Add code, labels and logic for button checks and LED patterns

main_loop:

   LDR R5, GPIOA_BASE
    LDR R3, [R5, #0x10]

    MOVS R5, #0b00000011      
    TST R3, R5                
    BEQ twoPressed      

    MOVS R5, #0b00000001      
    TST R3, R5                
    BEQ sw0          

    MOVS R5, #0b00000010      
    TST R3, R5                
    BEQ sw1          

    MOVS R5, #0b00000100      
    TST R3, R5                
    BEQ sw2          

    MOVS R5, #0b00001000      
    TST R3, R5                
    BEQ sw3          

    BL long_delay            
    ADDS R2, R2, #1            @ Increment LEDs by 1
    B write_leds 

    B main_loop               @ Loop back to the start if no match


 sw0_and_sw1:	
    
    ADDS R2, R2, #2            @ Increment LEDs by 2
    BL short_delay          
    B write_leds              
                

sw0:
    BL long_delay              
    ADDS R2, R2, #2            @ Increment LEDs by 2
    B write_leds              

sw1:
    BL short_delay            
    ADDS R2, R2, #1            @ Increment LEDs by 1
    B write_leds              

sw2:
   
    MOVS R2, #0xAA             @ Set pattern to 0xAA
    B write_leds              



sw3:
    B main_loop                @ Just loop without updating LEDs

long_delay:
    LDR R6, LONG_DELAY_CNT     
    B delay_loop

short_delay:
    LDR R6, SHORT_DELAY_CNT    

delay_loop:
    SUBS R6, R6, #1
    BNE delay_loop:             
    BX LR            @exit loop        


write_leds:
	STR R2, [R1, #0x14]
	B main_loop

@ LITERALS; DO NOT EDIT
	.align
RCC_BASE: 			.word 0x40021000
AHBENR_GPIOAB: 		.word 0b1100000000000000000
GPIOA_BASE:  		.word 0x48000000
GPIOB_BASE:  		.word 0x48000400
MODER_OUTPUT: 		.word 0x5555

@ TODO: Add your own values for these delays
LONG_DELAY_CNT: 	.word 1400000   @ 0.7 seconds
SHORT_DELAY_CNT: 	.word 600000    @ 0.3 seconds
