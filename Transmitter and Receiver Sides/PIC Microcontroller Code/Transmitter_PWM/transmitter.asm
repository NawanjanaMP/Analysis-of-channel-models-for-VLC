
_InitMain:

;transmitter.c,5 :: 		void InitMain() {
;transmitter.c,15 :: 		PORTC = 0;                          // set PORTC to 0
	CLRF       PORTC+0
;transmitter.c,16 :: 		TRISC = 0;                          // designate PORTC pins as output
	CLRF       TRISC+0
;transmitter.c,17 :: 		PWM1_Init(5000);                    // Initialize PWM1 module at 5KHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;transmitter.c,19 :: 		}
L_end_InitMain:
	RETURN
; end of _InitMain

_main:

;transmitter.c,21 :: 		void main() {
;transmitter.c,22 :: 		InitMain();
	CALL       _InitMain+0
;transmitter.c,26 :: 		PWM1_Start();                       // start PWM1
	CALL       _PWM1_Start+0
;transmitter.c,31 :: 		while (1) {
L_main0:
;transmitter.c,32 :: 		for(i=0; i<8; i++){
	CLRF       _i+0
	CLRF       _i+1
L_main2:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main11
	MOVLW      8
	SUBWF      _i+0, 0
L__main11:
	BTFSC      STATUS+0, 0
	GOTO       L_main3
;transmitter.c,33 :: 		if( arr[i] == 1){
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
	MOVLW      1
	XORWF      R1+0, 0
L__main12:
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;transmitter.c,34 :: 		PWM1_Set_Duty(191);
	MOVLW      191
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;transmitter.c,35 :: 		Delay_ms(500);
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
;transmitter.c,36 :: 		}
L_main5:
;transmitter.c,38 :: 		if( arr[i] == 0){
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
	GOTO       L__main13
	MOVLW      0
	XORWF      R1+0, 0
L__main13:
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;transmitter.c,39 :: 		PWM1_Set_Duty(64);
	MOVLW      64
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;transmitter.c,40 :: 		Delay_ms(500);
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
;transmitter.c,41 :: 		}
L_main7:
;transmitter.c,32 :: 		for(i=0; i<8; i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;transmitter.c,44 :: 		}
	GOTO       L_main2
L_main3:
;transmitter.c,73 :: 		}
	GOTO       L_main0
;transmitter.c,74 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
