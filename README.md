# WanderWatch – Distraction Monitoring Wristband  
**WiSH 2025 | Texas Instruments**

WanderWatch is a low-power wearable device designed to monitor and reduce user distraction in academic and self-study settings. Built under the **WiSH 2025 program by Texas Instruments**, the device integrates multiple physiological and contextual sensors to identify distraction triggers such as stress, drowsiness, noisy environments, and smartphone usage patterns.

---

## 🧠 Distraction Detection: Multimodal Signal Approach

WanderWatch continuously analyzes a combination of physical and environmental cues using the following sensor modules:

### 1. **Heart Rate Variability (HRV)** – _Drowsiness and Anxiety Detection_  
- Uses a PPG (Photoplethysmography) sensor to capture cardiac signals  
- Features such as **RMSSD**, **SDNN**, and **LF/HF ratio** are computed from heart rate intervals  
- Lower variability is associated with drowsiness or elevated stress levels

### 2. **Skin Conductance (GSR)** – _Stress Monitoring_  
- Measures electrodermal activity using a pair of Ag/AgCl electrodes  
- Sudden spikes in skin conductance correlate with anxiety or heightened arousal  
- Amplified using INA333 instrumentation amplifier and sampled via ADC

### 3. **sEMG for Thumb Motion Detection** – _Smartphone Usage_  
- Captures fine muscular activity from thumb using AFE4404 EMG sensor  
- Motion patterns indicate swipe or tap gestures linked to mobile distractions  
- Threshold-based gesture classification is used to trigger alerts or feedback

### 4. **Inertial Measurement Unit (IMU)** – _Handwriting and Note-taking Detection_  
- Analyzes x, y, z acceleration and angular motion to identify handwriting activity  
- Writing produces characteristic low-entropy, repetitive motion signals  
- Absence of such patterns may indicate loss of focus

### 5. **Microphone** – _Environmental Noise Monitoring_  
- Measures ambient sound pressure using analog MEMS microphone  
- Sound levels exceeding 40 dB trigger an internal classification as "noisy"  
- Low-pass filtering and peak detection help isolate human speech and sudden disturbances

All sensors are cyclically activated every 5 minutes in ultra-low-power mode, ensuring extended battery life and high energy efficiency.

---

## 👩‍💻 My Role – ASIC Implementation of IMU Signal Processing

To reduce power, size, and cost while increasing customizability, one sensory input was selected for full **ASIC-level implementation**. I was responsible for designing and verifying the **hardware pipeline for IMU-based handwriting detection**.

### 📌 Sensor Used:
- **LSM6DSL** – 3-axis accelerometer + gyroscope module, streaming x/y/z data over SPI at 25 Hz

### 🧮 Signal Processing Pipeline (Implemented in RTL):

1. **Vector Amplitude Calculation**  
   - Acceleration and gyro signals from x, y, z axes are squared and summed  
   - Square root is computed using **Newton-Raphson iterative approximation**  
   - Division within the algorithm is handled by a **CORDIC-based divider** architecture

2. **Entropy Series Extraction**  
   - Using a moving window of 8 samples, entropy is computed over amplitude series  
   - Features such as **entropy RMS**, **entropy average** are derived in parallel blocks

3. **Zero-Crossing Rate (ZCR)**  
   - Original (non-amplitude) motion signal is used to compute ZCR  
   - High ZCR typically indicates non-writing movement or random hand motion

4. **Classification Logic**  
   - Entropy RMS and ZCR are fed into a **hardware-implemented Decision Tree**  
   - The decision tree is realized as a **combinational MUX tree**, acting as a low-latency classifier  
   - Output is a binary signal indicating handwriting activity (`1`) or not (`0`)

This entire processing chain was written in **Verilog HDL**, synthesized and verified using **Xilinx Vivado**. Custom testbenches were created for functional validation of all blocks.

---

## 📁 Repository Contents

- `WiSH Project.pdf` — Complete project presentation including system architecture, sensor details, power budget, and implementation methodology  
- `ASIC Implementation of IMU data/` — All relevant **Xilinx Vivado project files**, including RTL, simulation, synthesis, and constraint files

---

