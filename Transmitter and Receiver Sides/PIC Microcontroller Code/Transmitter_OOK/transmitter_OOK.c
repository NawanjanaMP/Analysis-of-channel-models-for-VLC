int arr[8] ={1,1,0,1,0,1,0,0};
int i;

void main() {
  PORTC = 0;      // set PORTC to 0
  TRISC = 0;     // designate PORTC pins as output
  
 
 while (1) {
     for(i=0; i<8; i++){
          if( arr[i] == 1){
            PORTC.RC2 = 1; //LED ON
            //PORTC = 1; //LED ON
              Delay_ms(500);
          }

          if( arr[i] == 0){
              PORTC.RC2 = 0; //LED OFF
             // PORTC = 0; //LED OFF
             Delay_ms(500);
          }
     }
}
}

