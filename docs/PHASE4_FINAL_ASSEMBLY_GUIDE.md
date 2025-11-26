# Phase 4: Final Hardware Assembly Guide

## The Simple Approach

**Don't think about building a whole robot.** Focus on ONE mission at a time.

| Mission | Goal | Time |
|---------|------|------|
| **Mission 1** | Mechanical Setup (Drilling & Mounting) | ~1-2 hours |
| **Mission 2** | Power Backbone (The "Veins") | ~30 min |
| **Mission 3** | Sensors (The "Nerves") | ~30 min |
| **Mission 4** | Actuators & Camera (The "Muscles" & "Eyes") | ~30 min |

---

## Materials Checklist

Before starting, gather everything:

### Enclosure & Mounting
- [ ] Waterproof enclosure (IP65 or better)
- [ ] Cable glands (various sizes)
- [ ] Standoffs, screws, double-sided tape/velcro
- [ ] Drill with appropriate bits

### Power System
- [ ] Solar Panel
- [ ] MPPT Charge Controller
- [ ] 12V Battery
- [ ] Master Switch
- [ ] 12V Fuse Box
- [ ] Fuses: 5A (x3), 10A (x1)
- [ ] Wires: 16 AWG (power), 22 AWG (signals)

### Electronics
- [ ] Arduino Mega 2560
- [ ] ESP32 DevKit (with Screw Terminal Extender)
- [ ] ESP32-CAM module
- [ ] Logic Level Shifter (on perfboard)
- [ ] L298N Motor Driver
- [ ] Servo Motor

### Sensors
- [ ] DO Sensor (DFRobot)
- [ ] HX711 + Load Cell
- [ ] DS3231 RTC Module
- [ ] Voltage Sensor Module
- [ ] I2C LCD Display

---

# MISSION 1: Mechanical Setup

**Goal:** Get everything attached to the box. NO WIRING YET.

## Step 1: Empty the Box
Open your waterproof enclosure. It should be empty.

## Step 2: Plan the Floor

Place these components inside and move them around until they fit nicely:
- Battery (keep at bottom - it's heavy)
- MPPT Controller
- Fuse Box
- Arduino + ESP32 perfboard

```
┌─────────────────────────────────────────┐
│           ENCLOSURE LAYOUT              │
│                                         │
│  ┌──────────┐  ┌──────────┐            │
│  │ Arduino  │  │  ESP32   │            │
│  │  Mega    │  │  BLE     │            │
│  └──────────┘  └──────────┘            │
│                                         │
│  ┌──────────┐  ┌────────────────┐      │
│  │  L298N   │  │   Fuse Box     │      │
│  │  Motor   │  │                │      │
│  └──────────┘  └────────────────┘      │
│                                         │
│  ┌──────────────────────────────┐      │
│  │         MPPT Controller      │      │
│  └──────────────────────────────┘      │
│                                         │
│  ┌──────────────────────────────┐      │
│  │         BATTERY (bottom)     │      │
│  └──────────────────────────────┘      │
│                                         │
│  [Master Switch]   [LCD Window]         │
└─────────────────────────────────────────┘
```

## Step 3: Drill Holes

Mark where wires need to come in:
- Solar panel cables
- Motor wires
- Sensor probe (DO sensor)
- Load cell wires

Drill those holes. Install cable glands.

## Step 4: Screw Everything Down

Mount components securely:
- **Battery**: Must be secured (screws or straps)
- **Arduino/ESP32**: Standoffs (10mm) to elevate
- **Lighter modules**: Double-sided tape or velcro OK
- **Fuse Box**: Screws, easy access for fuse replacement

---

# STOP. MISSION 1 COMPLETE. TAKE A BREAK.

---

# MISSION 2: Power Backbone

**Goal:** Get power to the Fuse Box and Arduino. NO SENSORS YET.

## Power Flow Diagram

```
SOLAR PANEL
     │
     ▼
┌─────────────┐
│    MPPT     │
│ Controller  │
└──┬──────┬───┘
   │      │
   ▼      ▼
BATTERY   LOAD OUTPUT
           │
           ▼
      ┌─────────┐
      │  FUSE   │ (15A main)
      └────┬────┘
           │
           ▼
      ┌─────────┐
      │ MASTER  │
      │ SWITCH  │
      └────┬────┘
           │
           ▼
┌──────────────────────────────────┐
│         12V FUSE BOX             │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐   │
│  │ 5A │ │ 5A │ │10A │ │ 5A │   │
│  └──┬─┘ └──┬─┘ └──┬─┘ └──┬─┘   │
└─────┼──────┼──────┼──────┼─────┘
      │      │      │      │
      ▼      ▼      ▼      ▼
   Arduino  CAM   Motor  Spare
    Vin     5V    Driver
```

## Step 1: Battery to MPPT Controller

```
Battery (+) ────→ MPPT "BATT+" terminal
Battery (-) ────→ MPPT "BATT-" terminal
```

**Do this FIRST** - most MPPT controllers require battery before solar.

## Step 2: Solar to MPPT Controller

```
Solar (+) ────→ MPPT "SOLAR+" terminal
Solar (-) ────→ MPPT "SOLAR-" terminal
```

## Step 3: MPPT Load to Fuse Box

```
MPPT "LOAD+" ──→ 15A Fuse ──→ Master Switch ──→ Fuse Box (+)
MPPT "LOAD-" ──→ Fuse Box Ground Bus (-)
```

## Step 4: Power the Arduino

1. Insert **5A fuse** into Fuse Box Slot 1
2. Wire it:
```
Fuse Box Slot 1 Output ────→ Arduino "Vin" pin
Fuse Box Ground        ────→ Arduino "GND" pin
```

## Step 5: Power the Motor Driver

1. Insert **10A fuse** into Fuse Box Slot 2
2. Wire it:
```
Fuse Box Slot 2 Output ────→ L298N "+12V" terminal
Fuse Box Ground        ────→ L298N "GND" terminal
```

---

# STOP. MISSION 2 COMPLETE.

## TEST NOW:
1. Turn on Master Switch
2. Does Arduino LED light up?
3. Does Motor Driver LED light up?
4. If YES → Turn off and continue
5. If NO → Check connections with multimeter

---

# MISSION 3: Sensors (The "Nerves")

**Goal:** Connect sensors to Arduino. One group at a time.

## Group A: The I2C Pair (Pins 20 & 21)

These share the same pins:

### RTC Module (DS3231):
```
RTC VCC ────→ Arduino 5V
RTC GND ────→ Arduino GND
RTC SDA ────→ Arduino Pin 20 (SDA)
RTC SCL ────→ Arduino Pin 21 (SCL)
```

### LCD Display:
```
LCD VCC ────→ Arduino 5V
LCD GND ────→ Arduino GND
LCD SDA ────→ Arduino Pin 20 (SDA)  ← same as RTC
LCD SCL ────→ Arduino Pin 21 (SCL)  ← same as RTC
```

**Note:** Both devices share SDA/SCL - this is normal for I2C.

---

## Group B: The Analog Pair (Pins A0 & A1)

### Voltage Sensor (Battery Monitor):
```
Voltage Sensor VCC    ────→ Arduino 5V
Voltage Sensor GND    ────→ Arduino GND
Voltage Sensor Signal ────→ Arduino A0

Voltage Sensor (+) input ──→ Battery + (or MPPT Load+)
Voltage Sensor (-) input ──→ Battery - (Ground)
```

### DO Sensor (Dissolved Oxygen):
```
DO Sensor VCC    ────→ Arduino 5V
DO Sensor GND    ────→ Arduino GND
DO Sensor Signal ────→ Arduino A1
```

---

## Group C: The Load Cell (Pins 8 & 9)

### HX711 Amplifier:
```
HX711 VCC ────→ Arduino 5V
HX711 GND ────→ Arduino GND
HX711 DT  ────→ Arduino Pin 8
HX711 SCK ────→ Arduino Pin 9
```

Load cell wires to HX711:
```
HX711 E+ ────→ Load Cell Red
HX711 E- ────→ Load Cell Black
HX711 A+ ────→ Load Cell White
HX711 A- ────→ Load Cell Green
```
*(Wire colors may vary - check your load cell datasheet)*

---

# STOP. MISSION 3 COMPLETE.

All input devices (sensors) are now connected!

---

# MISSION 4: Actuators & Camera

**Goal:** Connect the things that move or see.

## Motor Driver Logic Wires

```
L298N IN1 ────→ Arduino Pin 10
L298N IN2 ────→ Arduino Pin 11
L298N ENA ────→ Arduino Pin 12 (PWM speed control)
```

## Motor Power Wires

Connect your 12V gear motor:
```
Motor Wire 1 ────→ L298N OUT1
Motor Wire 2 ────→ L298N OUT2
```

## Servo Motor

```
Servo Signal (Orange/Yellow) ────→ Arduino Pin 6
Servo VCC (Red)              ────→ Arduino 5V
Servo GND (Brown/Black)      ────→ Arduino GND
```

## ESP32-CAM (Power Only!)

```
ESP32-CAM 5V  ────→ Arduino 5V (or dedicated 5V supply)
ESP32-CAM GND ────→ Arduino GND
```

**That's it!** The camera communicates via WiFi - no data wires needed.

### IMPORTANT: Flash ESP32-CAM BEFORE mounting!

1. **Connect FTDI programmer:**
```
FTDI 5V  ────→ ESP32-CAM 5V
FTDI GND ────→ ESP32-CAM GND
FTDI TX  ────→ ESP32-CAM U0R
FTDI RX  ────→ ESP32-CAM U0T
GND      ────→ ESP32-CAM IO0  ← REQUIRED FOR UPLOAD
```

2. **Update WiFi credentials** in `firmware/camera_server/camera_server.ino`:
```cpp
const char* WIFI_SSID = "YourWiFiName";
const char* WIFI_PASSWORD = "YourPassword";
```

3. **Upload in Arduino IDE:**
   - Board: "AI Thinker ESP32-CAM"
   - Click Upload

4. **After upload:**
   - Disconnect IO0 from GND
   - Press RESET button
   - Open Serial Monitor (115200 baud)
   - Look for IP address
   - Test video stream in browser: `http://[IP_ADDRESS]/stream`

5. **Mount in waterproof housing** aimed at pond

---

# YOU ARE DONE!

## Quick Reference: Arduino Pin Summary

| Pin | Connected To |
|-----|-------------|
| Vin | 12V from Fuse Box |
| 5V | Powers ESP32, sensors, servo |
| GND | Common ground |
| A0 | Voltage Sensor |
| A1 | DO Sensor |
| D6 | Servo |
| D8 | HX711 DT |
| D9 | HX711 SCK |
| D10 | L298N IN1 |
| D11 | L298N IN2 |
| D12 | L298N ENA |
| D18 (TX1) | → Logic Shifter → ESP32 RX2 |
| D19 (RX1) | → Logic Shifter → ESP32 TX2 |
| D20 (SDA) | RTC + LCD (shared) |
| D21 (SCL) | RTC + LCD (shared) |

---

## Troubleshooting

### No Power?
1. Master switch ON?
2. Check main 15A fuse
3. Check individual fuses in fuse box
4. Measure battery voltage with multimeter

### Arduino Not Starting?
1. Check Vin (should be 7-12V)
2. Try USB power to isolate issue

### Motor Not Spinning?
1. Check 12V at motor driver
2. Verify control pins (10, 11, 12)
3. Test motor directly with 12V

### ESP32-CAM No Video?
1. Correct WiFi credentials?
2. Stable 5V power?
3. Correct IP address?

---

## Next Steps

**Phase 5:** Update Arduino firmware to read real sensors (replace mock data)

**Phase 6:** Calibrate sensors and deploy at pond
