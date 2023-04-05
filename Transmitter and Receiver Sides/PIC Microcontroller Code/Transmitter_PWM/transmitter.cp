#line 1 "F:/LEC Notes/Semester 07/FYP/PIC/Transmitter_PWM/transmitter.c"

int arr[8] ={1,1,1,1,0,0,0,0};
int i;

void InitMain() {









 PORTC = 0;
 TRISC = 0;
 PWM1_Init(5000);

}

void main() {
 InitMain();



 PWM1_Start();




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
#line 73 "F:/LEC Notes/Semester 07/FYP/PIC/Transmitter_PWM/transmitter.c"
 }
}
