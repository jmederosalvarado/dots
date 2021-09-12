# My makefile based configurations

Run `make` to setup your machine. Run `make clean` to undo the setup.

> **Note:**: This setup assumes you are using ArchLinux

# Some stuff that are not automatically managed

## Packages

| system         | utils     | nvim          |
| -------------- | --------- | ------------- |
| base           | reflector | python-pynvim |
| base-devel     | libnotify |               |
| linux          | man-db    |               |
| linux-firmware |           |               |
| grub           |           |               |
| os-prober      |           |               |
| efibootmgr     |           |               |
| netctl         |           |               |

## Dell XPS 15 9570

Following arch linux dell xps 15 9570 guide at [arch wiki](https://wiki.archlinux.org/title/Dell_XPS_15_9570)

### Graphics

Blacklist nvidia drivers. Put this in `/etc/modprobe.d/blacklist.conf`

```conf
blacklist nouveau
```

## MPD Setup

Copy the example configuration in `mpd.conf`

```shell
cp /usr/share/doc/mpd/mpdconf.example /etc/mpd.conf
```

Create mpd directory `mkdir ~/.config/mpd` and their files

```
touch ~/.config/mpd/mpd.db
touch ~/.config/mpd/mpd.log
touch ~/.config/mpd/mpd.pid
```

Open `mpd.conf` and configure

```conf
music_directory      "~/path_to_music"
db_file              "~/.config/mpd/mpd.db"
log_file             "~/.config/mpd/mpd.log"
pid_file             "~/.config/mpd/mpd.pid"
user                 "your user"
bind_to_address      "any"
port                 "6600"
auto_update          "yes"

audio_output {
    type         "pulse"
    name         "My Pulse Output"
    server       "127.0.0.1"
}

filesystem_charset   "UTF-8"
```

Uncomment the line `load-module module-native-protocol-tcp` in `/etc/pulse/default.pa` and set the ip 127.0.0.1

```
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
```

Restart pulseaudio

## Chromium/Chrome

Add this to `chromium-flags.conf` to use dark mode and wayland

```
--enable-features=WebUIDarkMode,UseOzonePlatform
--force-dark-mode
--ozone-platform=wayland
```
