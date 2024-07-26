#include <DIYables_IRcontroller.h> // DIYables_IRcontroller library
#include <ESP32Servo.h>
#define IR_RECEIVER_PIN 27 // The ESP32 pin GPIO27 connected to IR controller


DIYables_IRcontroller_21 irController(IR_RECEIVER_PIN, 200); // debounce time is 200ms
Servo myServo;
Servo myServo1;
const int servoPin = 26;
const int ledPin = 25; // Pin connected to LED
const int sensorPin = 33; // Pin connected to PIR sensor
const unsigned long delayTime = 10 * 1000; // 10 seconds delay time in ms
volatile bool motionDetected = false; // Flag to indicate motion detection
unsigned long lastMillis = 0; // Time when motion was last detected

// Debouncing variables
unsigned long lastIRReceiveTime = 0; // Time when the last IR signal was received
const unsigned long debounceDelay = 300; // Minimum delay between consecutive IR signals in ms

int currentAngle = 0; // Global variable to track the servo position

void IRAM_ATTR pirISR() {
  motionDetected = true;
}

void setup() {
  Serial.begin(9600);
  irController.begin();
  myServo.attach(servoPin);
  myServo.write(0); // Set initial position
  pinMode(ledPin, OUTPUT);
  pinMode(sensorPin, INPUT);
  digitalWrite(ledPin, LOW); // Ensure LED is off initially
  Serial.println("Setup completed");

  // Attach interrupt to PIR sensor pin
  attachInterrupt(digitalPinToInterrupt(sensorPin), pirISR, RISING);
}

void gradualMove(int targetAngle, int duration) {
  int steps = 150; // Number of steps for smooth movement
  float totalChange = targetAngle - currentAngle;
  int stepDelay = duration / steps;

  Serial.print("Moving from ");
  Serial.print(currentAngle);
  Serial.print(" to ");
  Serial.print(targetAngle);
  Serial.println(" degrees");

  for (int i = 0; i <= steps; i++) {
    float progress = (float)i / steps;
    float easedProgress = progress * progress; // Quadratic easing function (ease-in)
    int newAngle = currentAngle + (int)(totalChange * easedProgress);
    myServo.write(newAngle);
    delay(stepDelay); // Ensure the step delay is calculated properly
  }
  myServo.write(targetAngle); // Ensure final position is accurate
  currentAngle = targetAngle; // Update the current angle
  Serial.print("Moved to ");
  Serial.print(targetAngle);
  Serial.println(" degrees");
}

void loop() {
  unsigned long currentMillis = millis();

  // Handle PIR sensor state
  if (motionDetected) {
    digitalWrite(ledPin, HIGH); // Turn on the LED
    Serial.println("Motion detected, LED turned on");
    motionDetected = false; // Reset the motion detected flag
    lastMillis = currentMillis; // Record time of motion detection
  } else if (currentMillis - lastMillis >= delayTime) {
    digitalWrite(ledPin, LOW); // Turn off the LED after delayTime
    Serial.println("Motion end, LED turned off");
  }

  // Handle IR remote input
  Key21 key = irController.getKey();
  if (key != Key21::NONE && (currentMillis - lastIRReceiveTime >= debounceDelay)) {
    Serial.print("Received key: ");
    Serial.println((int)key);
    lastIRReceiveTime = currentMillis; // Update last IR receive time
    switch (key) {
      case Key21::KEY_VOL_MINUS:
        Serial.println("Volume - key pressed");
        gradualMove(0, 1000); // Move to 0 degrees over 1 second
        Serial.println("Moved to 0 degrees");
        break;

      case Key21::KEY_VOL_PLUS:
        Serial.println("Volume + key pressed");
        gradualMove(90, 1000); // Move to 90 degrees over 1 second
        Serial.println("Moved to 90 degrees");
        break;
        
      default:
        Serial.println("WARNING: undefined key:");
        break;
    }
  }
}
