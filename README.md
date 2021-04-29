# dotfiles

My skript for automating the installation and configuration of a linux system after a fresh install.


<img src="https://github.com/ndz-v/dotfiles/blob/wsl/media/desktop.png" width="300" height="200">

## Installation

```shell
sh -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ndz-v/dotfiles/wsl/remote-setup.sh`"
```

### Explanation

The script above downloads the master branch of this repo and starts setup.sh execution.

### Apps that are installed

* Apt packages: calibre, curl, entr, ffmpeg, git, graphviz, grub-customizer, latexmk, latte-dock, libnotify-bin, libreoffice, lm-sensors, postgresql, python3-pip, rename, scrcpy, shellcheck, silversearcher-ag, texlive-full, translate-shell, tree, ufw, zsh, zsh-syntax-highlighting

* Python packages: youtube-dl, pylint, autopep8, pandocfilters, jupyter, pandas, eyed3

* Individual downloands and installation: Guake, obs-studio, kdenlive, pandoc, Oh-My-Zsh, libinput-gestures, Visual Studio Code and Extensions

## General tips

### Disable tlp USB autosuspend

```bash
sudo nano /etc/tlp.conf
```

Set value to 0
```bash
USB_AUTOSUSPEND = 0
```

File transfer and USB connections were breaking

### Disable wifi powersaving

```bash
sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```

Change value from 3 to 2

#### Weird WiFi-Problems

If WiFi is disconnecting from time to time, disable wpa_supplicant.service and enable it again

```bash
sudo systemctl stop wpa_supplicant.service
sudo systemctl disable wpa_supplicant.service
```

Reboot

```bash
sudo systemctl start wpa_supplicant.service
sudo systemctl enable wpa_supplicant.service
```
Reboot again

### Improve boot time for linux

Exists to ensure that the boot process can access remote resources and slows down boot process.
Disable and mask the service to decrease boot time.
```bash
sudo systemctl disable NetworkManager-wait-online.service # disables service on start up
sudo systemctl mask NetworkManager-wait-online.service # disables dbus based invocation
```

### Kernel flags for turning off spectre patches ([make linux fast again](https://make-linux-fast-again.com))

```bash
GRUB_CMDLINE_LINUX_DEFAULT="nouveau.modeset=0 acpi_rev_override=1 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off tsx=on tsx_async_abort=off mitigations=off"
```
Graphics problem on Dell XPS 15: dedicated graphics is powered although intel hybrid card is selected. Results in greater power consumption and battery drainage.

Uninstall and purge everything from nvidia.

```bash
sudo apt-get remove --purge "nvidia*"
sudo apt-get autoremove && sudo apt-get autoclean
```
Check if anyithing is still there from nvidia and purge it

```bash
dpkg -l | grep nvidia
sudo dpkg -r --purge *nvidia*
```

Without rebooting install the latest nvidia driver again and reboot

```bash
sudo apt-get install nvidia-driver-40
```

```bash
nouveau.modeset=0 acpi_rev_override=1
```
Use these flags as a workaround for the faulty nvidia driver. Only if a reinstall of the driver doesn't help.

### If audio is not working with headphones

```bash
alsactl restore
```

### Audio config to switch to headphones on startup

```bash
cd /usr/share/pulseaudio/alsa-mixer/paths
sudo nano analog-output-lineout.conf
```

Edit this line

```.conf
[Element Headphone+LO]
switch = on
```
