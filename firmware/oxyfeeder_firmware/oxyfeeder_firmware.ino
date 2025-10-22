/*
  OxyFeeder Firmware (Phase 1 - Scaffold with Simulated Data)

  Targets: Arduino Mega 2560 (Main controller)

  References:
  - Hardware overview: power, sensors, actuators, MCU roles
  - Sensor list: DO sensor, Load Cell + HX711, RTC, Voltage Sensor
  - System logic: INPUT → PROCESS → OUTPUT cycle

  This sketch scaffolds the full firmware structure using simulated data so
  mobile app development can proceed in parallel. Replace simulation stubs
  with real sensor integrations in later phases.
*/

// ----------------------------------------------------------------------------
// 1) Global Variables - current system status (simulated for now)
// ----------------------------------------------------------------------------

float currentDissolvedOxygenMgL = 0.0; // mg/L
int currentFeedLevelPercent = 0;       // % 0..100
int currentBatteryPercent = 0;         // % 0..100

// Feeding schedule simulation helpers
unsigned long lastFeedMillis = 0;
const unsigned long feedIntervalMs = 30UL * 1000UL; // simulate feed every 30s

// ----------------------------------------------------------------------------
// 2) Function Stubs (Simulation) - replace with real sensor code later
// ----------------------------------------------------------------------------

// Simulate Dissolved Oxygen (mg/L)
float readDissolvedOxygen() {
  // TODO: Replace with real DO sensor reading (analog read + calibration)
  return 7.8; // realistic placeholder value
}

// Simulate Feed Level (%)
int readFeedLevel() {
  // TODO: Replace with load cell + HX711 reading converted to percent
  return 62; // realistic placeholder value
}

// Simulate Battery Status (%)
int readBatteryVoltage() {
  // TODO: Replace with voltage sensor reading and mapping to percentage
  return 85; // realistic placeholder value
}

// Simulate motor control for feeding
void controlFeederMotor(int durationSeconds) {
  // TODO: Replace with actual motor driver control via L298N pins
  Serial.print("MOTOR: Dispensing feed for ");
  Serial.print(durationSeconds);
  Serial.println(" seconds.");
  delay((unsigned long)durationSeconds * 1000UL);
}

// ----------------------------------------------------------------------------
// 3) setup() - initialization
// ----------------------------------------------------------------------------

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect (needed for some boards/USB)
  }

  Serial.println("OxyFeeder Firmware Initializing...");
  Serial.println("USB Serial: Ready for debug messages");
  Serial.println("Hardware Serial1: Ready for ESP32 communication");
  // TODO: Initialize sensors here (HX711, DO sensor interface, voltage sensor, RTC, etc.)
  // TODO: Initialize motor driver pins and default states
  Serial.println("Setup complete - entering main loop");
}

// ----------------------------------------------------------------------------
// 4) loop() - main control cycle (INPUT -> PROCESS -> OUTPUT)
// ----------------------------------------------------------------------------

void loop() {
  // INPUT: Read sensors (simulated)
  currentDissolvedOxygenMgL = readDissolvedOxygen();
  currentFeedLevelPercent = readFeedLevel();
  currentBatteryPercent = readBatteryVoltage();

  // PROCESS: Core logic (placeholder)
  // TODO: Add RTC-based check here to trigger scheduled feeding
  // For now, simulate a feeding event every 30 seconds
  unsigned long now = millis();
  if (now - lastFeedMillis >= feedIntervalMs) {
    lastFeedMillis = now;
    controlFeederMotor(10); // dispense for 10 seconds
  }

  // OUTPUT: Print structured status packet (e.g., JSON) for ESP32/app
  Serial1.print("{");
  Serial1.print("\"do\": ");
  Serial1.print(currentDissolvedOxygenMgL, 1);
  Serial1.print(", \"feed\": ");
  Serial1.print(currentFeedLevelPercent);
  Serial1.print(", \"battery\": ");
  Serial1.print(currentBatteryPercent);
  Serial1.println("}");

  // Loop cadence: simulate 5-second sensor update interval
  delay(5000);
}


