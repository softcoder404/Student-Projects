#define smokeSensor A0
#define buzzer 13
#define falseAlarmButton 8
#define triggerValue 56
bool smokeFlag = false;
uint8_t counter = 0;
void setup() {
  Serial.begin(9600);
  pinMode(smokeSensor, INPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(falseAlarmButton, INPUT_PULLUP);
}

void loop() {
  int smokeValue = map(analogRead(smokeSensor), 0 , 1023, 0, 100); //sensor value was mapped to 0 - 100
  if (smokeValue >= triggerValue) smokeFlag = true;
  else stayAtRest();
  while (smokeFlag) {
    //raise an alarm and wait for 10 secs before sending sms
    Serial.println("Smoke Detected Please Take precaution before the count down : " + String(counter));
    digitalWrite(buzzer, HIGH);
    if (digitalRead(falseAlarmButton) == LOW) {
      Serial.println("False Alarm Detected...Keep Calm");
      smokeFlag = false;
    }
    if (counter >= 20) {
      //sendSms
      Serial.println("Sending sms...");
      sendSms();
      delay(3000);
      //break out of while loop
      Serial.println("going back to safe mode");
      delay(1000);
      smokeFlag = false;
    }
    counter ++;
    delay(500);
  }

}

void stayAtRest() {
  Serial.println("System At Safe Mode... Keep Calm!");
  digitalWrite(buzzer, LOW);
  smokeFlag = false;
  counter = 0;
  delay(500);
}

void sendSms() {
  //sms code goes here
}
