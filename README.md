# Orange Pi Zero 2W TFT Touchscreen Setup

This repository contains configuration files and setup scripts for enabling ADS7846-based TFT touchscreens on the Orange Pi Zero 2W single-board computer.

## Overview

This automated setup configures an ADS7846 touchscreen controller on Orange Pi Zero 2W via SPI interface. The solution includes:

- **Device Tree Overlay**: Configures SPI1 interface with PI6 interrupt handling
- **Intelligent Setup Script**: Auto-detects Orange Pi/Armbian tools and installs dependencies
- **X11 Touch Calibration**: Pre-configured calibration matrix for immediate use
- **Multi-Distribution Support**: Works with apt (Debian/Ubuntu) and pacman (Arch) package managers

## Hardware Compatibility

- **Board**: Orange Pi Zero 2W (Allwinner H616 SoC)
- **Touchscreen Controller**: TI ADS7846 (SPI-based)
- **Connection**: SPI1 interface with PI6 interrupt pin

## Repository Structure

```
├── dts/
│   └── lcd-touch.dts               # Device Tree overlay for touchscreen
├── usr/
│   └── 99-calibration.conf-3508    # X11 touchscreen calibration
├── setup.sh                        # Automated setup script
└── LICENSE                         # MIT License
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
- **SPI Frequency**: 2MHz (2,000,000 Hz)
- **Touch Resolution**: X: 200-3900, Y: 200-3900 (12-bit ADC)
- **Pressure Range**: 0-255
- **X-Plate Resistance**: 150 ohms
- **Interrupt Type**: Edge falling (IRQ_TYPE_EDGE_FALLING)

### Setup Script Features

The `setup.sh` script automatically:
- **Detects overlay tools**: `orangepi-add-overlay` or `armbian-add-overlay`
- **Applies device tree overlay**: Compiles and installs to `/boot/overlay-user/`
- **Configures SPI parameters**: Sets `param_spidev_spi_cs=1` in boot environment
- **Installs X11 packages**: `xserver-xorg-input-evdev` (Debian/Ubuntu) or `xf86-input-evdev` (Arch)
- **Copies calibration files**: Places X11 configuration in `/usr/share/X11/xorg.conf.d/`
- **Verifies installation**: Checks for successful overlay compilation

### Touchscreen Calibration

The calibration file (`99-calibration.conf-3508`) includes:
- **Calibration Matrix**: `3945 233 3939 183`
- **Axis Swapping**: Disabled (`SwapAxes = 0`)
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

3. **Update the calibration file** with new values in `/usr/share/X11/xorg.conf.d/99-calibration.conf`

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

- Orange Pi OS (Ubuntu-based)
- Armbian
- Ubuntu for ARM
- Debian ARM
- Arch Linux ARM

## Tested Operating Systems

| OS Distribution | Version | Kernel | Status | Notes |
|----------------|---------|--------|--------|-------|
| Orange Pi OS | Ubuntu 24.04 (Noble) | 6.1.x | ✅ Tested | **Recommended** - Successfully installed and working |
| Armbian | Latest | 6.x.x | ⚠️ Issues | touchscreen not working |
| Ubuntu ARM | 22.04 LTS | 5.15.0 | ❓ Not tested | No testing data available |
| Debian ARM | 12 (Bookworm) | 6.1.0 | ❓ Not tested | No testing data available |
| Arch Linux ARM | Latest | 6.4.x | ❓ Not tested | No testing data available |

**Testing Results:**
- ✅ **Fully working**: Confirmed by developer testing
- ❌ **Known issues**: Problems identified during testing
- 🔄 **Needs testing**: Community feedback welcome

**Test Images Reference:** [Google Drive - Test Results](https://drive.google.com/drive/folders/1YMomjG-_jbfYcXZ0_D60XK93awgyjcVq?usp=drive_link)

## Contributing

Feel free to submit issues and enhancement requests. When contributing:

1. Test changes on actual hardware
2. Update documentation for any configuration changes
3. Ensure compatibility with multiple Linux distributions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Orange Pi community for hardware documentation
- Armbian project for overlay tools
- Linux kernel ADS7846 driver maintainers
