// Variable for storing incoming value
char Incoming_value = 0;

void setup()
{
  // Sets the data rate in bits per second (baud) 
  // for serial data transmission
  Serial.begin(9600);
  
  // Sets digital pin 8 as output pin
  pinMode(8, OUTPUT);
  
  // Initializes the pin 8 to LOW (i.e., OFF)
  digitalWrite(8, LOW);
}

void loop()
{
  if (Serial.available() > 0)
  {
    // Read the incoming data and store it in the variable
    Incoming_value = Serial.read();
    
    // Print value of Incoming_value in Serial monitor
    Serial.print(Incoming_value);
    Serial.print("\n");
    
    // Checking whether value of the variable
    // is equal to 0
    if (Incoming_value == '0')
      digitalWrite(8, LOW); // If value is 0, turn OFF the device
      
    // Checking whether value of the variable
    // is equal to 1
    else if (Incoming_value == '1')
      digitalWrite(8, HIGH); // If value is 1, turn ON the device
  }
  
  // Adding a delay before running the loop again
  delay(1);
  
}
