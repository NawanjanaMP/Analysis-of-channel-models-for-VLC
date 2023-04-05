//unsigned short current_duty, old_duty, current_duty1, old_duty1;
int arr[8] ={1,1,1,1,0,0,0,0};
int i;

void InitMain() {
  //ANSEL  = 0;                         // Configure AN pins as digital
  //ANSELH = 0;
  //C1ON_bit = 0;                       // Disable comparators
  //C2ON_bit = 0;

  //PORTA = 255;
  //TRISA = 255;                        // configure PORTA pins as input
 // PORTB = 0;                          // set PORTB to 0
  //TRISB = 0;                          // designate PORTB pins as output
  PORTC = 0;                          // set PORTC to 0
  TRISC = 0;                          // designate PORTC pins as output
  PWM1_Init(5000);                    // Initialize PWM1 module at 5KHz
  //PWM2_Init(5000);                    // Initialize PWM2 module at 5KHz
}

void main() {
  InitMain();
  //current_duty  = 16;                 // initial value for current_duty
  //current_duty1 = 16;                 // initial value for current_duty1

  PWM1_Start();                       // start PWM1
  //PWM2_Start();                       // start PWM2
  //PWM1_Set_Duty(current_duty);        // Set current duty for PWM1
  //PWM2_Set_Duty(current_duty1);       // Set current duty for PWM2

  while (1) {    
     for(i=0; i<8; i++){
          if( arr[i] == 1){
             PWM1_Set_Duty(191);
              Delay_ms(500);
          }
          
          if( arr[i] == 0){
             PWM1_Set_Duty(64);
             Delay_ms(500);
          }
     
     
     }
  
                       // endless loop
  /*  if (RA0_bit) {                    // button on RA0 pressed
      Delay_ms(40);
      current_duty++;                 // increment current_duty
      PWM1_Set_Duty(current_duty);
     }

    if (RA1_bit) {                    // button on RA1 pressed
      Delay_ms(40);
      current_duty--;                 // decrement current_duty
      PWM1_Set_Duty(current_duty);
     }

    if (RA2_bit) {                    // button on RA2 pressed
      Delay_ms(40);
      current_duty1++;                // increment current_duty1
      PWM2_Set_Duty(current_duty1);
     }

    if (RA3_bit) {                    // button on RA3 pressed
      Delay_ms(40);
      current_duty1--;                // decrement current_duty1
      PWM2_Set_Duty(current_duty1);
     }

    Delay_ms(5);                      // slow down change pace a little
    */
  }
}