int myLED;

int bitPosition = 0;
byte recievedByte = 0x00;

bool readB = false;

void setup() {
  // put your setup code here, to run once:
  pinMode ( myLED, INPUT);
  Serial.begin(9600);
}

void loop() {   
  // put your main code here, to run repeatedly:
  if (analogRead(A0) < 50) {
    delay(850);
    for (int i = 0; i < 8; i++) { 
      if (analogRead(A0) > 50)
      {
        bitSet(recievedByte, bitPosition);
      }
      delay(500);
      //Serial.println("Read Value: " + (String)digitalRead(mySignal));
      bitPosition ++;
    }
  }

  if(bitPosition > 7) {
    Serial.write(recievedByte);
    bitPosition = 0;
    recievedByte = 0x00;
  }

  bitPosition = 0;
  recievedByte = 0x00;

}
  
bool readValue() {
  int zeroCount = 0;
  int oneCount = 0;
 
  for (int i = 0; i < 5; i++) {
    if (analogRead(A0) > 45)
    {
      oneCount ++;
    } else {
      zeroCount++;
    }
  }
  return (zeroCount < oneCount);
}
