int myLED = 8;

void setup( ){
  pinMode ( myLED, OUTPUT);
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  digitalWrite(myLED, HIGH);
  
  if (Serial.available() > 0) {
    byte recievedData = Serial.read();
    digitalWrite(myLED, LOW);
    delay(500);
    for (int i = 0; i < 8; i++) { 
      digitalWrite ( myLED, bitRead(recievedData, i));
      delay ( 500);
    }
    digitalWrite(myLED, HIGH);
  }
}
