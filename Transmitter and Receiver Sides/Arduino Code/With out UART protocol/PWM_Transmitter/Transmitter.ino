int led = 6;
//int arr[8] = {1,0,1,0,1,0,1,0};
int arr[8] = {1,1,1,1,0,0,0,0};
//byte arr[8] = {1,1,1,1,0,0,0,0};
//byte sendByte = 0b11110000;
int bitPosition = 0;

void setup() {
  // put your setup code here, to run once:
  pinMode(led, OUTPUT);
   Serial.begin(9600);

  // for(int i=0; i<8; i++){
 // if(arr[i]== 1){
 //   analogWrite(led, 191);
 //   delay(1000);
   
 // }
  // if(arr[i]== 0){
  //    analogWrite(led, 64);
  //     delay(1000);
 //  }
  
   
//}
}

void loop() {
  // put your main code here, to run repeatedly:
 
for(int i=0; i<8; i++){
  if(arr[i]== 1){
    analogWrite(led, 191);
    delay(1000);
   
  }
   if(arr[i]== 0){
    analogWrite(led, 64);
       delay(1000);
   }
  

}

}
