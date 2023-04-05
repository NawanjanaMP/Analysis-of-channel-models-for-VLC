
_main:

;transmitter_OOK.c,4 :: 		void main() {
;transmitter_OOK.c,5 :: 		PORTC = 0;                          // set PORTC to 0
	CLRF       PORTC+0
;transmitter_OOK.c,6 :: 		TRISC = 0;                          // designate PORTC pins as output
	CLRF       TRISC+0
;transmitter_OOK.c,9 :: 		while (1) {
L_main0:
;transmitter_OOK.c,10 :: 		for(i=0; i<8; i++){
	CLRF       _i+0
	CLRF       _i+1
L_main2:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main10
	MOVLW      8
	SUBWF      _i+0, 0
L__main10:
	BTFSC      STATUS+0, 0
	GOTO       L_main3
;transmitter_OOK.c,11 :: 		if( arr[i] == 1){
	MOVF       _i+0, 0
	MOVWF      R0+0
	MOVF       _i+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _arr+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R1+1
	MOVLW      0
	XORWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main11
	MOVLW      1
	XORWF      R1+0, 0
L__main11:
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;transmitter_OOK.c,12 :: 		PORTC.RC2 = 1; //LED ON
	BSF        PORTC+0, 2
;transmitter_OOK.c,14 :: 		Delay_ms(500);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
	NOP
	NOP
;transmitter_OOK.c,15 :: 		}
L_main5:
;transmitter_OOK.c,17 :: 		if( arr[i] == 0){
	MOVF       _i+0, 0
	MOVWF      R0+0
	MOVF       _i+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _arr+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R1+1
	MOVLW      0
	XORWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main12
	MOVLW      0
	XORWF      R1+0, 0
L__main12:
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;transmitter_OOK.c,18 :: 		PORTC.RC2 = 0; //LED OFF
	BCF        PORTC+0, 2
;transmitter_OOK.c,20 :: 		Delay_ms(500);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
	NOP
;transmitter_OOK.c,21 :: 		}
L_main7:
;transmitter_OOK.c,10 :: 		for(i=0; i<8; i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;transmitter_OOK.c,24 :: 		}
	GOTO       L_main2
L_main3:
;transmitter_OOK.c,25 :: 		}
	GOTO       L_main0
;transmitter_OOK.c,26 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
