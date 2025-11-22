/*
  ESP32 Communicator - BLE Bridge for OxyFeeder
  
  This ESP32 firmware acts as a communication bridge between the Arduino Mega
  and mobile devices. It receives JSON data from the Arduino via Serial2 and
  broadcasts it over Bluetooth Low Energy (BLE) to the mobile app.
  
  Hardware Setup:
  - ESP32 receives data from Arduino Mega via Serial2 (hardware serial)
  - ESP32 broadcasts data over BLE to mobile devices
  - USB Serial available for debugging
  
  Data Flow: Arduino Mega (Serial1) -> ESP32 (Serial2) -> BLE -> Mobile App
*/

// ----------------------------------------------------------------------------
// 1) Include Libraries for BLE
// ----------------------------------------------------------------------------

#include "BLEDevice.h"
#include "BLEServer.h"
#include "BLEUtils.h"
#include "BLE2902.h"

// ----------------------------------------------------------------------------
// 2) BLE Service and Characteristic UUIDs
// ----------------------------------------------------------------------------

// Define unique UUIDs for our OxyFeeder BLE service
#define SERVICE_UUID        "0000abcd-0000-1000-8000-00805f9b34fb"
#define CHARACTERISTIC_UUID "0000abce-0000-1000-8000-00805f9b34fb"

// ----------------------------------------------------------------------------
// 3) Global Variables
// ----------------------------------------------------------------------------

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

// Buffer for receiving JSON data from Arduino
String receivedData = "";
const int MAX_DATA_LENGTH = 200; // Maximum expected JSON string length

// ----------------------------------------------------------------------------
// 4) BLE Server Callback Classes
// ----------------------------------------------------------------------------

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("BLE Client Connected");
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("BLE Client Disconnected");
    }
};

// ----------------------------------------------------------------------------
// 5) setup() - Initialize all systems
// ----------------------------------------------------------------------------

void setup() {
  // Initialize USB Serial for debugging
  Serial.begin(115200);
  while (!Serial) {
    ; // Wait for serial port to connect
  }
  
  // Initialize Serial2 to communicate with Arduino Mega
  // RX2=Pin 17 (receives from Arduino TX1), TX2=Pin 16 (sends to Arduino RX1)
  Serial2.begin(9600, SERIAL_8N1, 17, 16); // RX=17, TX=16
  
  Serial.println("ESP32 OxyFeeder Communicator Starting...");
  Serial.println("Serial2 initialized for Arduino communication");
  
  // Initialize BLE
  BLEDevice::init("OxyFeeder");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create BLE Service
  BLEService *pService = pServer->getServer()->createService(SERVICE_UUID);
  
  // Create BLE Characteristic for data transmission
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_NOTIFY
                    );
  
  // Add descriptor for notifications
  pCharacteristic->addDescriptor(new BLE2902());
  
  // Start the service
  pService->start();
  
  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  
  Serial.println("BLE Server Started - Advertising as 'OxyFeeder'");
  Serial.println("Waiting for mobile app connection...");
  Serial.println("Ready to receive data from Arduino via Serial2");
}

// ----------------------------------------------------------------------------
// 6) loop() - Main communication loop
// ----------------------------------------------------------------------------

void loop() {
  // Check for incoming data from Arduino via Serial2
  if (Serial2.available()) {
    char incomingChar = Serial2.read();
    
    // Build complete JSON string
    if (incomingChar == '\n' || incomingChar == '\r') {
      // End of JSON string received
      if (receivedData.length() > 0) {
        Serial.print("Received from Arduino: ");
        Serial.println(receivedData);
        
        // Update BLE characteristic if device is connected
        if (deviceConnected) {
          pCharacteristic->setValue(receivedData.c_str());
          pCharacteristic->notify();
          Serial.println("Data sent to mobile app via BLE");
        } else {
          Serial.println("No BLE client connected - data not sent");
        }
        
        // Clear buffer for next message
        receivedData = "";
      }
    } else {
      // Add character to buffer (ignore if buffer gets too long)
      if (receivedData.length() < MAX_DATA_LENGTH) {
        receivedData += incomingChar;
      }
    }
  }
  
  // Handle BLE connection status changes
  if (!deviceConnected && oldDeviceConnected) {
    // Client disconnected - restart advertising
    delay(500); // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising(); // restart advertising
    Serial.println("Restarting BLE advertising");
    oldDeviceConnected = deviceConnected;
  }
  
  if (deviceConnected && !oldDeviceConnected) {
    // Client connected
    oldDeviceConnected = deviceConnected;
  }
  
  // Small delay to prevent overwhelming the system
  delay(10);
}
