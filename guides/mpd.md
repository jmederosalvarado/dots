Installation

`pacman -S mpd mpc`

**MPD**

copy the example configuration in `mpd.conf`

```
# cp /usr/share/doc/mpd/mpdconf.example /etc/mpd.conf
```

create mpd directory `mkdir ~/.config/mpd` and their files

```
touch ~/.config/mpd/mpd.db
touch ~/.config/mpd/mpd.log
touch ~/.config/mpd/mpd.pid
```

open `mpd.conf` and configure

```
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
        server       "127.0.0.1"
}

filesystem_charset   "UTF-8"
```

uncomment the line `load-module module-native-protocol-tcp` in `/etc/pulse/default.pa` and set the ip 127.0.0.1


```
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
```

restart pulseaudio

add `server 127.0.0.1` to the audio_output in `mpd.conf`

```
audio_output {
        type         "pulse"
        name         "My Pulse Output"
        server       "127.0.0.1"
}
```
