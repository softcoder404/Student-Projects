#include <LiquidCrystal.h>
#define smokeSensor A5
#define buzzer 6
#define overrideButtonn 5
#define triggerValue 56
bool smokeFlag = false;
uint8_t counter = 0;
LiquidCrystal lcd(8, 9, 10, 11, 12, 13);
void setup() {
  Serial.begin(9600);
  lcd.begin(16, 2);
  lcd.setCursor(0, 0);
  lcd.print(" Smoke Detector ");
  lcd.setCursor(0, 1);
  lcd.print("And  SMS  Alert ");
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
  lcd.clear();
}

void loop() {
  int smokeValue = map(analogRead(smokeSensor), 0 , 1023, 0, 100); //sensor value was mapped to 0 - 100
  if (smokeValue >= triggerValue) {
    lcd.clear();
    smokeFlag = true;
  }
  else stayAtRest();
  while (smokeFlag) {
    //raise an alarm and wait for 10 secs before sending sms
    lcd.setCursor(0, 0);
    lcd.print("Smoke Detected!");
    lcd.setCursor(0, 1);
    lcd.print("Take Precaution");
    digitalWrite(buzzer, HIGH);
    if (digitalRead(overrideButtonn) == LOW) {
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("  False Alarm !");
      lcd.setCursor(0, 1);
      lcd.print("Smoke  Override");
      digitalWrite(buzzer, LOW);
      delay(2000);
      smokeFlag = false;
    }
    if (counter >= 20) {
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print(" Sending Sms...");
      lcd.setCursor(0, 1);
      lcd.print("Please  Wait!!!");
      sendSms();
      delay(1000);
      sendSms2();
      lcd.clear();
      smokeFlag = false;
    }
    counter ++;
    delay(500);
  }

}

void stayAtRest() {
  //Serial.println("System At Safe Mode... Keep Calm!");
  lcd.setCursor(0, 0);
  lcd.print(" System At Safe");
  lcd.setCursor(0, 1);
  lcd.print("     Mode      ");
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
