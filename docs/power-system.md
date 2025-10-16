# OxyFeeder: Solar Energy & Power Regulation System

## 1. Architecture
Solar Panel → MPPT Controller → 12V Battery → Fuse → Buck Converters → Devices  

## 2. Components
- **Solar Panel:** 50W monocrystalline — high efficiency  
- **MPPT Controller:** 10A, maximizes charge on cloudy days  
- **Battery:** 12V 20Ah (48h autonomy)  
- **Buck Converters:** Step-down to 5V/3.3V efficiently  
- **Voltage Sensor:** Monitors battery level  
- **Capacitors:** Smooth noise near MCUs/motors  

## 3. Safety
- Inline fuse between battery and load  
- Reverse polarity & surge protection  
- Proper wire gauging (14–16 AWG)  
- Low-voltage disconnect (MPPT feature)

## 4. Field Maintenance
- Tilt panel = local latitude  
- Clean panel quarterly  
- Inspect wiring for corrosion  
- Maintain battery temperature range
