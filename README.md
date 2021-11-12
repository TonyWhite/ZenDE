# Zen DE (alpha)

Desktop Environment User-friendly Script-based

## Actual situation

The bulk of the project is strictly **X11 dependent** and has not been tested with Wayland.

## Install

This product is in alpha version and you must be a Linux expert to avoid troubles.

1. Create a Virtual Machine (recommended).
2. Install Debian Stable without X11, Desktop Environment or other WMs.
3. Install SSH Server (recommended).
4. Wait for the end of installation.
5. Download "install.sh" and execute it with root permissions.

```
wget https://raw.githubusercontent.com/TonyWhite/ZenDE/main/install.sh
chmod +x install.sh
./install.sh
```

6. If you are in VM Debian, you need to prepare kernel before install VirtualBoxAdditions

```
sudo apt-get install build-essential module-assistant
sudo m-a prepare
```

Now you can install VirtualBoxAdditions.
