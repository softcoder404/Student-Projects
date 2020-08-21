#define smokeSensor A0
#define buzzer 13
#define falseAlarmButton 8
#define triggerValue 56
void setup() {
  Serial.begin(9600);
  pinMode(smokeSensor, INPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(falseAlarmButton, INPUT_PULLUP);
}

void loop() {
  int smokeValue = map(analogRead(smokeSensor),0 ,1023, 0, 100); //sensor value was mapped to 0 - 100
  if(smokeValue >= triggerValue) takeAction();
  else stayAtRest();  
  }
