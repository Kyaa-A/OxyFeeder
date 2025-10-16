# OxyFeeder: Hardware Architecture Overview

## 1. Subsystems
### MCU
- Arduino Mega 2560: Main controller  
- ESP32: Handles wireless comms and GSM alerts  

### Power
- 50W Solar Panel → MPPT Controller → 12V 20Ah Battery → DC Buck Converters (5V, 3.3V)  

### Sensors
- DO Sensor, Load Cell + HX711, RTC, Voltage Sensor  

### Actuators
- 12V DC Gear Motor + L298N Driver  

### UI/Alerts
- OLED Display, LEDs, Buzzer  

### Connectivity
- ESP32 WiFi/Bluetooth + SIM800L GSM + ESP32-CAM  

---

## 2. Signal Flow
**Power:** Solar → MPPT → Battery → Buck → MCUs & Sensors  
**Data:** Sensors → Arduino → ESP32 → App / GSM  
**Control:** Arduino → Motor Driver → Feeder  
**Alerts:** ESP32 → App/GSM  

---

## 3. MCU Integration
- Arduino ↔ ESP32 via UART (logic level shifted 5V↔3.3V).  
- Arduino: Real-time control; ESP32: Communication and camera.  
- Simple JSON or delimited data protocol.
