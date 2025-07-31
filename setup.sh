#!/bin/sh

DTS_FILE="./dts/lcd-touch.dts"
DTBO_FILE="/boot/overlay-user/lcd-touch.dtbo"

# Detect overlay tool
if command -v orangepi-add-overlay >/dev/null 2>&1; then
	TOOL="orangepi-add-overlay"
elif command -v armbian-add-overlay >/dev/null 2>&1; then
	TOOL="armbian-add-overlay"
else
	echo "No suitable overlay tool found (orangepi-add-overlay or armbian-add-overlay)."
	exit 1
fi

# Apply overlay
sudo $TOOL "$DTS_FILE"

# Inject param_spidev_spi_cs=1 into armbianEnv.txt or orangepiEnv.txt
if [ -f /boot/armbianEnv.txt ]; then
	ENV_FILE="/boot/armbianEnv.txt"
elif [ -f /boot/orangepiEnv.txt ]; then
	ENV_FILE="/boot/orangepiEnv.txt"
else
	echo "No environment file (armbianEnv.txt or orangepiEnv.txt) found in /boot."
	exit 1
fi

if grep -q '^param_spidev_spi_cs=' "$ENV_FILE"; then
	sudo sed -i 's/^param_spidev_spi_cs=.*/param_spidev_spi_cs=1/' "$ENV_FILE"
else
	echo "param_spidev_spi_cs=1" | sudo tee -a "$ENV_FILE" >/dev/null
fi

# Install xserver-xorg-input-evdev if on aarch64/arm or Debian/Ubuntu/Arch
if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "armv7l" ] || grep -qiE 'debian|ubuntu' /etc/os-release; then
	if command -v apt-get >/dev/null 2>&1; then
		if ! dpkg -s xserver-xorg-input-evdev >/dev/null 2>&1; then
			sudo apt-get update
			sudo apt-get install -y xserver-xorg-input-evdev
		fi
	fi
elif grep -qi 'arch' /etc/os-release; then
	if command -v pacman >/dev/null 2>&1; then
		if ! pacman -Qs xorg-server-xvfb >/dev/null 2>&1 && ! pacman -Qs xorg-server >/dev/null 2>&1; then
			sudo pacman -Sy --noconfirm xorg-server
		fi
		if ! pacman -Qs xf86-input-evdev >/dev/null 2>&1; then
			sudo pacman -Sy --noconfirm xf86-input-evdev
		fi
	fi
fi

sudo cp -rf /usr/share/X11/xorg.conf.d/10-evdev.conf /usr/share/X11/xorg.conf.d/45-evdev.conf
sudo cp -f ./usr/99-calibration.conf-3508 /etc/X11/xorg.conf.d/99-calibration.conf

# Optionally, check if .dtbo was created
if [ -f "$DTBO_FILE" ]; then
	echo "Overlay applied successfully: $DTBO_FILE"
	echo "Reboot system to apply changes."
else
	echo "Overlay application may have failed. Please check logs."
fi