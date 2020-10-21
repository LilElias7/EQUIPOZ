PROCESSOR 16F887
    #include <xc.inc>
    ;configuración de los fuses
    CONFIG FOSC=INTRC_NOCLKOUT
    CONFIG WDTE=OFF
    CONFIG PWRTE=ON
    CONFIG MCLRE=OFF
    CONFIG CP=OFF
    CONFIG CPD=OFF
    CONFIG BOREN=OFF
    CONFIG IESO=OFF
    CONFIG FCMEN=OFF
    CONFIG LVP=OFF
    CONFIG DEBUG=ON
    
    CONFIG BOR4V=BOR40V
    CONFIG WRT=OFF

    
    PSECT udata
 tick:
    DS 1
 counter:
    DS 1
 counter2:
    DS 1
    
tick2:
    DS 1
 counter3:
    DS 1
 counter4:
    DS 1
   
    PSECT code
    delay:
    movlw 0xFF
    movwf counter
    counter_loop:
    movlw 0xFF
    movwf tick
    tick_loop:
    decfsz tick,f
    goto tick_loop
    decfsz counter,f
    goto counter_loop
    return
    
    delay2:
    movlw 0x64
    movwf counter3
    counter4_loop:
    movlw 0x64
    movwf tick2
    tick2_loop:
    decfsz tick2,f
    goto tick2_loop
    decfsz counter3,f
    goto counter4_loop
    return
    
     pin0:
    btfss PORTC,0
    bsf PORTA,0
    call delay
    bcf  PORTA,0
    call delay
    retfie
    
    pin7:
    btfss PORTC,7
    bsf  PORTA,0
    call delay2
    bcf  PORTA,0
    call delay2
    retfie
    
    
PSECT resetVec,class=CODE,delta=2
	PAGESEL main
	goto main
	
PSECT isr,class=CODE,delta=2
	isr:
        btfss INTCON,0
	retfie
	clrf  PORTC

        btfss PORTB,0
	goto pin7
	bcf  INTCON,0
	bcf PORTB,0
	bsf PORTC,0
	goto pin0
	retfie

        btfss PORTB,7
	goto pin0
	bcf  INTCON,0
	bcf PORTB,7
	bsf PORTC,7
	goto pin7
	retfie
	
PSECT main,class=CODE,delta=2
	main:
    clrf INTCON
    movlw   0b11001000
    movwf INTCON
    BANKSEL OSCCON
    movlw   0b01110000
    movwf   OSCCON
    BANKSEL OPTION_REG
    movlw   0b01000000
    movwf   OPTION_REG
    BANKSEL WPUB
    movlw   0b11111111
    movwf   WPUB
    BANKSEL IOCB
    movlw   0b11111111
    movwf   IOCB
    BANKSEL PORTA
    clrf    PORTA
    BANKSEL PORTB
    clrf    PORTB
    movlw   0xFF
    BANKSEL TRISB
    movlw   0xFF
    movwf   TRISB
    BANKSEL ANSEL
    movlw   0x00
    movwf   ANSEL
    BANKSEL ANSELH
    movlw   0x00
    movwf   ANSELH
    BANKSEL PORTC
    clrf    PORTC
    BANKSEL TRISC
    clrf    TRISC
    BANKSEL TRISA
    clrf    TRISA
     loop:
    BANKSEL PORTA
    call    delay
    movlw   0x01
    xorwf   PORTA,f
    goto loop
    END


