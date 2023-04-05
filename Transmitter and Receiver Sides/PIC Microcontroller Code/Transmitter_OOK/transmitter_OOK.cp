#line 1 "F:/LEC Notes/Semester 07/FYP/PIC/Transmitter_OOK/transmitter_OOK.c"
int arr[8] ={1,1,1,1,0,0,0,0};
int i;

void main() {
 PORTC = 0;
 TRISC = 0;


 while (1) {
 for(i=0; i<8; i++){
 if( arr[i] == 1){
 PORTC.RC2 = 1;

 Delay_ms(500);
 }

 if( arr[i] == 0){
 PORTC.RC2 = 0;

 Delay_ms(500);
 }


 }
}
}
