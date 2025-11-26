# Phase 4: Final Hardware Assembly Guide

## Overview

This guide covers the complete physical assembly of the OxyFeeder system, including mounting, power wiring, and sensor/actuator connections.

**Prerequisites:**
- Phase 3 complete (BLE communication working)
- All components and materials ready
- Basic soldering skills
- Multimeter for testing

---

## Materials Checklist

### Enclosure & Mounting
- [ ] Waterproof enclosure (IP65 or better)
- [ ] Cable glands (various sizes for different wire gauges)
- [ ] DIN rails or mounting plates
- [ ] Standoffs and screws
- [ ] Zip ties and cable management clips

### Power System
- [ ] Solar Panel (appropriate wattage for your setup)
- [ ] MPPT Charge Controller
- [ ] 12V Battery (lead-acid or lithium)
- [ ] Master Switch (toggle or rocker)
- [ ] 12V Fuse Box (blade fuse type)
- [ ] Blade fuses (various amperage: 5A, 10A, 15A)
- [ ] In-line fuse holder (for main power)
- [ ] Wire (14-16 AWG for power, 22 AWG for signals)
- [ ] Ring terminals and spade connectors
- [ ] Heat shrink tubing

### Electronics
- [ ] Arduino Mega 2560
- [ ] ESP32 DevKit with Screw Terminal Extender
- [ ] ESP32-CAM module
- [ ] Logic Level Shifter (already assembled on perfboard)
- [ ] L298N Motor Driver
- [ ] Servo Motor (for feed gate)

### Sensors
- [ ] DFRobot Dissolved Oxygen Sensor
- [ ] HX711 Load Cell Amplifier + Load Cell
- [ ] DS3231 RTC Module
- [ ] Voltage Sensor Module (for battery monitoring)
- [ ] I2C LCD Display (16x2 or 20x4)

### Connectors & Misc
- [ ] JST connectors (for sensor connections)
- [ ] Screw terminals
- [ ] Perfboard (for additional connections)
- [ ] Silicone sealant (for waterproofing)
- [ ] FTDI Programmer (for ESP32-CAM)

---

## Sub-Phase 4A: Component Mounting

### Step 1: Plan Enclosure Layout

Before drilling or mounting anything, plan the layout:

```
┌─────────────────────────────────────────────────────────────┐
│  ENCLOSURE TOP VIEW                                         │
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐                     │
│  │ Arduino │  │  ESP32  │  │ESP32-CAM│                     │
│  │  Mega   │  │  BLE    │  │         │                     │
│  └─────────┘  └─────────┘  └─────────┘                     │
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────────────┐             │
│  │  L298N  │  │  HX711  │  │   Fuse Box      │             │
│  │ Motor   │  │         │  │   (12V dist)    │             │
│  │ Driver  │  └─────────┘  └─────────────────┘             │
│  └─────────┘                                               │
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐                     │
│  │  RTC    │  │ Voltage │  │  Logic  │                     │
│  │ DS3231  │  │ Sensor  │  │ Shifter │                     │
│  └─────────┘  └─────────┘  └─────────┘                     │
│                                                             │
│  ═══════════════════════════════════════                   │
│  [Master Switch]  [LCD Display Window]                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘

EXTERNAL (through cable glands):
- Solar panel wires
- Battery wires
- DO sensor cable
- Load cell wires
- Motor wires
- Servo wires
- ESP32-CAM (mounted externally, aimed at pond)
```

### Step 2: Prepare the Enclosure

1. **Mark cable gland positions** on the enclosure sides:
   - Bottom/side: Power cables (solar, battery)
   - Side: Sensor cables (DO sensor, load cell)
   - Side: Actuator cables (motor, servo)
   - Top/side: ESP32-CAM cable (if internal) or mount externally

2. **Drill holes** for cable glands using appropriate size drill bits

3. **Install cable glands** and tighten securely

4. **Cut LCD display window** if mounting LCD visible from outside

### Step 3: Mount Components Inside Enclosure

**Mounting Order (bottom to top):**

1. **Fuse Box** - Mount near power entry point
   - Use screws or DIN rail
   - Ensure easy access for fuse replacement

2. **Arduino Mega** - Central position
   - Use standoffs (at least 10mm) to elevate from enclosure floor
   - Allows airflow and prevents shorts

3. **ESP32 with Screw Terminal Extender** - Next to Arduino
   - Mount with standoffs
   - Position screw terminals for easy wire access

4. **L298N Motor Driver** - Away from sensitive electronics
   - May generate heat, keep ventilated
   - Mount with standoffs

5. **Logic Level Shifter Board** - Between Arduino and ESP32
   - Already assembled on perfboard
   - Mount with standoffs or double-sided tape

6. **HX711 Load Cell Amplifier** - Near Arduino
   - Small module, can use double-sided tape or small standoffs

7. **DS3231 RTC Module** - Near Arduino I2C pins
   - Install backup battery before mounting

8. **Voltage Sensor Module** - Near fuse box
   - Will connect to battery voltage

9. **LCD Display** - Mount visible through window or on enclosure lid

### Step 4: Mount External Components

1. **ESP32-CAM** - Mount in separate small waterproof housing
   - Position with clear view of pond/feeder
   - Run 2-wire cable (5V, GND) back to main enclosure
   - **IMPORTANT:** Flash the ESP32-CAM firmware BEFORE final mounting!

2. **DO Sensor** - Mount in water
   - Follow manufacturer positioning guidelines
   - Keep probe submerged at proper depth

3. **Load Cell** - Mount under feed hopper
   - Ensure proper load distribution
   - Protect from water

4. **Motor + Servo** - Mount at feeder mechanism
   - Motor for auger/dispenser
   - Servo for gate control

---

## Sub-Phase 4B: Power Wiring

### Power System Diagram

```
                                    ┌──────────────────┐
                                    │   SOLAR PANEL    │
                                    │   (DC Output)    │
                                    └────────┬─────────┘
                                             │
                                             │ (+) (-)
                                             ▼
                                    ┌──────────────────┐
                                    │      MPPT        │
                                    │   CONTROLLER     │
                                    │                  │
                                    │ SOLAR  BATT LOAD │
                                    │  IN    OUT  OUT  │
                                    └──┬──────┬────┬───┘
                                       │      │    │
                              ┌────────┘      │    └────────┐
                              │               │             │
                              ▼               ▼             ▼
                         (from solar)    ┌────────┐    ┌─────────┐
                                         │BATTERY │    │IN-LINE  │
                                         │  12V   │    │FUSE 15A │
                                         └────────┘    └────┬────┘
                                                            │
                                                            ▼
                                                    ┌───────────────┐
                                                    │ MASTER SWITCH │
                                                    │   (ON/OFF)    │
                                                    └───────┬───────┘
                                                            │
                                                            ▼
                           ┌────────────────────────────────────────────────┐
                           │              12V FUSE BOX                       │
                           │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐      │
                           │  │ 5A  │ │ 5A  │ │ 10A │ │ 5A  │ │ 5A  │      │
                           │  └──┬──┘ └──┬──┘ └──┬──┘ └──┬──┘ └──┬──┘      │
                           └─────┼───────┼───────┼───────┼───────┼─────────┘
                                 │       │       │       │       │
                                 ▼       ▼       ▼       ▼       ▼
                            Arduino   ESP32   Motor   ESP32   Future
                            Mega Vin  -CAM   Driver   (via    Expansion
                                       5V     12V   Arduino)
```

### Step 1: Connect Solar Panel to MPPT Controller

1. **TURN OFF everything** - no power connected yet

2. **Connect battery to MPPT FIRST** (most MPPT controllers require this)
   - Red wire: Battery (+) → MPPT "BATT+" terminal
   - Black wire: Battery (-) → MPPT "BATT-" terminal

3. **Connect solar panel to MPPT**
   - Red wire: Solar (+) → MPPT "SOLAR+" terminal
   - Black wire: Solar (-) → MPPT "SOLAR-" terminal

4. **Verify MPPT shows charging** (if sun is available)

### Step 2: Wire MPPT Load Output to Fuse Box

1. **Connect MPPT Load Output to In-Line Fuse**
   ```
   MPPT "LOAD+" → In-Line Fuse (15A) → Master Switch → Fuse Box (+)
   MPPT "LOAD-" → Fuse Box (-)
   ```

2. **Install Master Switch** in the positive line
   - This allows you to turn off entire system without disconnecting battery

3. **Connect to Fuse Box**
   - Run positive through switch to fuse box common positive
   - Run negative directly to fuse box common negative

### Step 3: Wire Fuse Box Outputs

**Fuse Box Terminal Assignments:**

| Terminal | Fuse | Connected To | Wire Gauge |
|----------|------|--------------|------------|
| 1 | 5A | Arduino Mega Vin | 18 AWG |
| 2 | 5A | ESP32-CAM (5V via buck converter*) | 20 AWG |
| 3 | 10A | L298N Motor Driver 12V | 16 AWG |
| 4 | 5A | Spare / Future | - |
| 5 | 5A | Spare / Future | - |

*Note: ESP32-CAM needs 5V, so if your fuse box is 12V, add a small buck converter (12V→5V) for the camera.

### Step 4: Wire Arduino Mega Power

```
Fuse Box Terminal 1 (+) ──→ Arduino Mega "Vin" pin
Fuse Box Ground (-)    ──→ Arduino Mega "GND" pin
```

**IMPORTANT:**
- Arduino Mega can accept 7-12V on Vin
- The onboard regulator converts to 5V for the board
- Arduino's 5V pin will power the ESP32 BLE module

### Step 5: Wire ESP32 BLE Module Power

The ESP32 BLE module is powered FROM the Arduino:

```
Arduino Mega 5V  ──→ ESP32 Screw Terminal "VIN"
Arduino Mega GND ──→ ESP32 Screw Terminal "GND"
```

This keeps both on the same power domain and simplifies wiring.

### Step 6: Wire ESP32-CAM Power

**Option A: Direct 5V from buck converter**
```
Fuse Box Terminal 2 (+12V) ──→ Buck Converter IN+
Fuse Box Ground (-)        ──→ Buck Converter IN-
Buck Converter OUT+ (5V)   ──→ ESP32-CAM "5V" pin
Buck Converter OUT- (GND)  ──→ ESP32-CAM "GND" pin
```

**Option B: From Arduino 5V (if current budget allows)**
```
Arduino Mega 5V  ──→ ESP32-CAM "5V" pin
Arduino Mega GND ──→ ESP32-CAM "GND" pin
```

**WARNING:** ESP32-CAM can draw 300-400mA during WiFi transmission. Ensure your power source can handle this.

### Step 7: Wire L298N Motor Driver Power

```
Fuse Box Terminal 3 (+12V) ──→ L298N "+12V" terminal
Fuse Box Ground (-)        ──→ L298N "GND" terminal
```

**Remove the 12V jumper** on L298N if your motor is 12V (the jumper enables onboard 5V regulator which isn't needed).

### Step 8: Power Verification Checklist

Before connecting any electronics, verify with multimeter:

- [ ] Battery voltage at MPPT: ~12-13V
- [ ] MPPT Load output: ~12-13V (when switch ON)
- [ ] Fuse box outputs: ~12-13V on each terminal
- [ ] Arduino Vin: 12V
- [ ] Arduino 5V pin: 5V (after Arduino powers up)
- [ ] ESP32-CAM power: 5V
- [ ] L298N 12V input: 12V

---

## Sub-Phase 4C: Sensor Wiring

### Arduino Mega Pin Assignment Reference

```
┌─────────────────────────────────────────────────────────────────┐
│                     ARDUINO MEGA 2560                           │
│                                                                 │
│  ANALOG PINS:                                                   │
│    A0 ─── Voltage Sensor (Battery Monitor)                      │
│    A1 ─── DO Sensor (Dissolved Oxygen)                          │
│    A2 ─── (spare)                                               │
│    A3 ─── (spare)                                               │
│                                                                 │
│  DIGITAL PINS:                                                  │
│    D6 ─── Servo PWM                                             │
│    D8 ─── HX711 DT (Data)                                       │
│    D9 ─── HX711 SCK (Clock)                                     │
│    D10 ── L298N IN1                                             │
│    D11 ── L298N IN2                                             │
│    D12 ── L298N ENA (PWM speed control)                         │
│                                                                 │
│  I2C PINS (directly on board):                                  │
│    D20 (SDA) ─── RTC DS3231 SDA, LCD SDA (shared bus)          │
│    D21 (SCL) ─── RTC DS3231 SCL, LCD SCL (shared bus)          │
│                                                                 │
│  SERIAL1 PINS (to ESP32 via Logic Level Shifter):              │
│    D18 (TX1) ─── Logic Shifter HV1 → LV1 → ESP32 RX2 (GPIO17)  │
│    D19 (RX1) ─── Logic Shifter HV2 → LV2 → ESP32 TX2 (GPIO16)  │
│                                                                 │
│  POWER:                                                         │
│    Vin ─── 12V from Fuse Box                                   │
│    GND ─── Common Ground                                        │
│    5V ──── To ESP32 VIN, sensors needing 5V                    │
│    3.3V ── To sensors needing 3.3V                             │
└─────────────────────────────────────────────────────────────────┘
```

### Step 1: Wire the Logic Level Shifter (Arduino ↔ ESP32)

This should already be done from Phase 2, but verify:

```
ARDUINO MEGA          LOGIC LEVEL SHIFTER       ESP32 (Screw Terminal)
─────────────         ───────────────────       ──────────────────────
5V           ───────→ HV (High Voltage)
GND          ───────→ GND ─────────────────────→ GND
TX1 (Pin 18) ───────→ HV1 ──→ LV1 ────────────→ RX2 (GPIO 17)
RX1 (Pin 19) ───────→ HV2 ──→ LV2 ────────────→ TX2 (GPIO 16)
                      LV (Low Voltage) ────────→ 3V3
```

### Step 2: Wire Dissolved Oxygen (DO) Sensor

**DFRobot Gravity DO Sensor:**

```
DO Sensor Board        Arduino Mega
───────────────        ────────────
VCC (Red)      ───────→ 5V
GND (Black)    ───────→ GND
Signal (Blue)  ───────→ A1
```

**Note:** The DO sensor may have a separate probe that connects to its board via BNC connector.

### Step 3: Wire Voltage Sensor (Battery Monitor)

**Voltage Sensor Module (0-25V):**

```
Voltage Sensor         Arduino Mega
──────────────         ────────────
VCC            ───────→ 5V
GND            ───────→ GND
S (Signal)     ───────→ A0

Input Side:
+ (Positive)   ───────→ Battery + (or Fuse Box +)
- (Negative)   ───────→ Battery - (GND)
```

**IMPORTANT:** This sensor uses a voltage divider. The formula to calculate actual voltage:
```
Actual Voltage = (Analog Reading / 1023.0) * 5.0 * 5.0
```
(The module has a 5:1 divider ratio)

### Step 4: Wire HX711 Load Cell Amplifier

```
HX711 Module           Arduino Mega
────────────           ────────────
VCC            ───────→ 5V
GND            ───────→ GND
DT (Data)      ───────→ D8
SCK (Clock)    ───────→ D9

Load Cell Side:
E+ (Excitation+) ─────→ Load Cell Red
E- (Excitation-) ─────→ Load Cell Black
A+ (Signal+)     ─────→ Load Cell White
A- (Signal-)     ─────→ Load Cell Green
```

**Note:** Load cell wire colors may vary. Refer to your specific load cell datasheet.

### Step 5: Wire DS3231 RTC Module

```
DS3231 RTC             Arduino Mega
──────────             ────────────
VCC            ───────→ 5V
GND            ───────→ GND
SDA            ───────→ D20 (SDA)
SCL            ───────→ D21 (SCL)
```

**Note:** Install CR2032 battery in RTC module to maintain time during power loss.

### Step 6: Wire I2C LCD Display

```
I2C LCD (with backpack) Arduino Mega
───────────────────────  ────────────
VCC             ───────→ 5V
GND             ───────→ GND
SDA             ───────→ D20 (SDA) ← shared with RTC
SCL             ───────→ D21 (SCL) ← shared with RTC
```

**I2C Address:** Usually 0x27 or 0x3F. Use I2C scanner sketch if unsure.

### Step 7: Wire L298N Motor Driver

```
L298N Motor Driver     Arduino Mega
──────────────────     ────────────
IN1            ───────→ D10
IN2            ───────→ D11
ENA            ───────→ D12 (PWM for speed control)
GND            ───────→ GND (signal ground)

Power Side (already done in 4B):
+12V           ← From Fuse Box
GND            ← From Fuse Box

Motor Output:
OUT1           ───────→ Motor Wire 1
OUT2           ───────→ Motor Wire 2
```

**Motor Control Logic:**
| IN1 | IN2 | ENA | Motor Action |
|-----|-----|-----|--------------|
| HIGH | LOW | HIGH | Forward |
| LOW | HIGH | HIGH | Reverse |
| LOW | LOW | X | Stop (coast) |
| HIGH | HIGH | X | Stop (brake) |

### Step 8: Wire Servo Motor

```
Servo Motor            Arduino Mega
───────────            ────────────
Signal (Orange/Yellow) → D6 (PWM)
VCC (Red)      ───────→ 5V (or external 5V if high-torque servo)
GND (Brown/Black) ────→ GND
```

**Note:** High-torque servos may draw too much current from Arduino 5V. Consider separate 5V supply.

### Step 9: Wire ESP32-CAM (Power Only)

**ESP32-CAM only needs power from the main system - WiFi handles communication:**

```
ESP32-CAM              Power Source
─────────              ────────────
5V             ───────→ 5V (from buck converter or Arduino)
GND            ───────→ GND (common ground)
```

**NO other connections needed** - ESP32-CAM communicates via WiFi, not wired to Arduino.

---

## Sub-Phase 4D: ESP32-CAM Setup

### IMPORTANT: Flash Before Final Installation!

The ESP32-CAM must be programmed BEFORE mounting in its final location.

### Step 1: Connect FTDI Programmer

```
FTDI Programmer        ESP32-CAM
───────────────        ─────────
5V             ───────→ 5V
GND            ───────→ GND
TX             ───────→ U0R (GPIO3)
RX             ───────→ U0T (GPIO1)

FOR PROGRAMMING MODE:
GND            ───────→ IO0 (GPIO0) ← IMPORTANT!
```

### Step 2: Update WiFi Credentials

Open `firmware/camera_server/camera_server.ino` and update:

```cpp
const char* WIFI_SSID = "YourWiFiNetworkName";
const char* WIFI_PASSWORD = "YourWiFiPassword";
```

### Step 3: Flash the Firmware

1. Open Arduino IDE
2. Select Board: **"AI Thinker ESP32-CAM"**
3. Select correct COM port
4. Click **Upload**
5. Wait for "Done uploading"

### Step 4: Test Before Installing

1. **Disconnect IO0 from GND**
2. **Press the RESET button** on ESP32-CAM
3. Open Serial Monitor (115200 baud)
4. Look for the IP address:
   ```
   WiFi connected
   Camera Ready! Use 'http://192.168.1.XXX/stream' to connect
   ```
5. Open that URL in a browser to verify video stream works

### Step 5: Final Installation

1. Mount ESP32-CAM in waterproof housing
2. Aim camera at pond/feeder area
3. Run only 2 wires back to main enclosure: **5V and GND**
4. Seal cable entry points

---

## Final Wiring Verification Checklist

### Power System
- [ ] Solar panel connected to MPPT (correct polarity)
- [ ] Battery connected to MPPT (correct polarity)
- [ ] MPPT Load output goes through fuse and switch
- [ ] Fuse box receives power when switch is ON
- [ ] All fuses installed and correct amperage
- [ ] Arduino Vin receives 12V
- [ ] Arduino 5V pin outputs 5V
- [ ] ESP32 BLE receives 5V from Arduino
- [ ] ESP32-CAM receives 5V
- [ ] L298N receives 12V

### Communication
- [ ] Logic level shifter properly connected
- [ ] Arduino TX1 → Shifter → ESP32 RX2
- [ ] Arduino RX1 → Shifter → ESP32 TX2
- [ ] ESP32 BLE can communicate with Arduino (test with Serial Monitor)

### Sensors
- [ ] DO sensor connected to A1
- [ ] Voltage sensor connected to A0
- [ ] HX711 DT connected to D8
- [ ] HX711 SCK connected to D9
- [ ] RTC SDA connected to D20
- [ ] RTC SCL connected to D21
- [ ] LCD SDA connected to D20 (shared)
- [ ] LCD SCL connected to D21 (shared)

### Actuators
- [ ] Motor driver IN1, IN2, ENA connected to D10, D11, D12
- [ ] Motor connected to driver OUT1, OUT2
- [ ] Servo signal connected to D6
- [ ] Servo power adequate

### ESP32-CAM
- [ ] Firmware flashed with correct WiFi credentials
- [ ] Video stream accessible via browser
- [ ] Mounted with clear view
- [ ] Only 5V and GND connected (no data wires)

### Grounding
- [ ] All grounds connected together (star ground recommended)
- [ ] No ground loops

---

## Troubleshooting Common Issues

### No Power
1. Check master switch is ON
2. Check main fuse (15A in-line)
3. Check individual fuse box fuses
4. Verify battery voltage with multimeter

### Arduino Not Powering Up
1. Check Vin voltage (should be 7-12V)
2. Check fuse for Arduino circuit
3. Try powering via USB to isolate issue

### ESP32 BLE Not Working
1. Verify 5V at ESP32 VIN
2. Check logic level shifter connections
3. Verify Serial1/Serial2 TX/RX are not swapped

### Sensors Not Reading
1. Verify sensor power (5V or 3.3V as required)
2. Check signal wire connections
3. Test with simple example sketches first

### Motor Not Running
1. Check 12V at motor driver
2. Verify control pins (IN1, IN2, ENA)
3. Test motor directly with 12V to verify motor works

### ESP32-CAM No Video
1. Check WiFi credentials
2. Verify 5V power (CAM needs stable 5V)
3. Check if IP address is correct
4. Ensure not blocked by firewall

---

## Next Steps

After completing Phase 4:

1. **Phase 5:** Update Arduino firmware to read real sensors
2. **Phase 6:** Calibrate sensors and deploy at pond

**Remember to commit your progress:**
```bash
git add .
git commit -m "docs: add Phase 4 final assembly guide"
git push
```
