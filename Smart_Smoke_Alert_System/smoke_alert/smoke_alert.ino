#define smokeSensor A5
#define buzzer 6
#define overrideButtonn 5
#define triggerValue 56
bool smokeFlag = false;
uint8_t counter = 0;
void setup() {
  Serial.begin(9600);
  pinMode(smokeSensor, INPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(overrideButtonn, INPUT_PULLUP);
  //Set SMS format to ASCII
  Serial.write("AT+CMGF=1\r\n");
  delay(2000);
  //Send new SMS command and message number
  Serial.write("AT+CMGS=\"+2347014235169\"\r\n");
  delay(1000);
  //Send SMS content
  Serial.write("There is a smart smoke detector, stay safe! stay out of fire!");
  delay(1000);
  //Send Ctrl+Z / ESC to denote SMS message is complete
  Serial.write(26);
}

void loop() {
  int smokeValue = map(analogRead(smokeSensor), 0 , 1023, 0, 100); //sensor value was mapped to 0 - 100
  if (smokeValue >= triggerValue) smokeFlag = true;
  else stayAtRest();
  while (smokeFlag) {
    //raise an alarm and wait for 10 secs before sending sms
    //Serial.println("Smoke Detected Please Take precaution before the count down : " + String(counter));
    digitalWrite(buzzer, HIGH);
    if (digitalRead(overrideButtonn) == LOW) {
      // Serial.println("False Alarm Detected...Keep Calm");
      smokeFlag = false;
    }
    if (counter >= 20) {
      sendSms();
      delay(1000);
      sendSms2();
      smokeFlag = false;
    }
    counter ++;
    delay(500);
  }

}

void stayAtRest() {
  //Serial.println("System At Safe Mode... Keep Calm!");
  digitalWrite(buzzer, LOW);
  smokeFlag = false;
  counter = 0;
  delay(500);
}

void sendSms() {
  Serial.begin(9600);
  delay(1000);
  //Set SMS format to ASCII
  Serial.write("AT+CMGF=1\r\n");
  delay(1000);
  //Send new SMS command and message number
  Serial.write("AT+CMGS=\"+2348037251470\"\r\n");
  delay(1000);
  //SMS content
  Serial.write("A serious smoke detected. THERE COULD BE FIRE OUTBREAK.");
  delay(1000);
  //Send Ctrl+Z / ESC to denote SMS message is complete
  Serial.write((char)26);
  delay(1000);
}

void sendSms2() {
  Serial.begin(9600);
  delay(1000);
  //Set SMS format to ASCII
  Serial.write("AT+CMGF=1\r\n");
  delay(1000);
  //Send new SMS command and message number
  Serial.write("AT+CMGS=\"+2349031919034\"\r\n");
  delay(1000);
  //SMS content
  Serial.write("A serious smoke detected. THERE COULD BE FIRE OUTBREAK");
  delay(1000);
  //Send Ctrl+Z / ESC to denote SMS message is complete
  Serial.write((char)26);
  delay(1000);
}
