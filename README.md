# Orange Pi Zero 2W TFT Touchscreen Setup

This repository contains configuration files and setup scripts for enabling ADS7846-based TFT touchscreens on the Orange Pi Zero 2W single-board computer.

## Overview

The setup includes:
- Device Tree Overlay (DTS) for ADS7846 touchscreen controller
- X11 calibration configuration for touch input
- Setup script for easy installation

## Hardware Compatibility

- **Board**: Orange Pi Zero 2W (Allwinner H616 SoC)
- **Touchscreen Controller**: TI ADS7846 (SPI-based)
- **Connection**: SPI1 interface with PI6 interrupt pin

## Repository Structure

```
├── dts/
│   └── lcd-touch.dts							# Device Tree overlay for touchscreen
├── usr/
│   └── 99-calibration.conf-3508  # X11 touchscreen calibration
└── setup.sh											# Automated setup script
```

## Prerequisites

- Orange Pi Zero 2W with Orange Pi OS, Armbian, or compatible Linux distribution
- Root/sudo access
- Internet connection for package installation
- ADS7846-based touchscreen connected via SPI

## Installation

### Quick Setup

1. **Clone or download this repository**:
   ```bash
   git clone https://github.com/jahrulnr/orangepi-spi-touchscreen.git
   cd orangepi-spi-touchscreen
   ```

2. **Run the setup script**:
   ```bash
   chmod +x setup.sh
   sudo ./setup.sh
   ```

3. **Reboot the system**:
   ```bash
   sudo reboot
   ```

## Configuration Details

### Device Tree Overlay

The `lcd-touch.dts` file configures:
- **SPI Interface**: SPI1 with Chip Select 1
- **Interrupt Pin**: PI6 (GPIO pin for touch detection)
- **SPI Frequency**: 2MHz
- **Touch Resolution**: 4096x4096 (12-bit ADC)
- **Pressure Range**: 0-65535

### Touchscreen Calibration

The calibration file (`99-calibration.conf-3508`) includes:
- **Calibration Matrix**: `3945 233 3939 183`
- **Axis Swapping**: Enabled for proper orientation
- **Device Matching**: Targets "ADS7846 Touchscreen"

## Customization

### Adjusting Calibration

To recalibrate the touchscreen:

1. **Install calibration tools**:
   ```bash
   sudo apt-get install xinput-calibrator
   ```

2. **Run calibration**:
   ```bash
   xinput_calibrator
   ```

3. **Update the calibration file** with new values in `/etc/X11/xorg.conf.d/99-calibration.conf`

### Changing SPI Settings

Modify the `lcd-touch.dts` file to adjust:
- `spi-max-frequency`: Change SPI speed
- `reg`: Change chip select number
- Pin assignments for different GPIO connections

## Hardware Wiring

For ADS7846 touchscreen connection to Orange Pi Zero 2W:

| ADS7846 Pin | Orange Pi Pin | Function |
|-------------|---------------|----------|
| VCC         | 3.3V          | Power    |
| GND         | GND           | Ground   |
| DIN         | SPI1_MOSI     | Data In  |
| DOUT        | SPI1_MISO     | Data Out |
| CLK         | SPI1_SCLK     | Clock    |
| CS          | SPI1_CS1      | Chip Select |
| IRQ         | PI6           | Interrupt |

## Supported Distributions

- Orange Pi OS (Debian-based)
- Armbian
- Ubuntu for ARM
- Debian ARM
- Arch Linux ARM

## Contributing

Feel free to submit issues and enhancement requests. When contributing:

1. Test changes on actual hardware
2. Update documentation for any configuration changes
3. Ensure compatibility with multiple Linux distributions

## License

This project is provided as-is for educational and development purposes.

## Acknowledgments

- Orange Pi community for hardware documentation
- Armbian project for overlay tools
- Linux kernel ADS7846 driver maintainers
