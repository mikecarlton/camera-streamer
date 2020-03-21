# Camera streaming

Simple scripts to send output from IP cameras to streaming services.

Primarily h264 to twitch

## Installation

1. Put scripts into `/usr/local/bin`:

   ```
   for i in twitch-*.sh ; do
     cp $i /usr/local/bin
   done
   ```
2. Put service files into `/etc/systemd/system`
   
   ```
   for i in systemd/twitch-*.service ; do
     cp $i /etc/systemd/system
   done
   ```
3. Enable the systemd services:

   ```
   cd systemd
   for i in twitch-*.service ; do
     systemctl enable --now $i
   done
   ```

## Updates
If you make changes, copy the updated file to `/etc/systemd/system` and do:

```
systemctl daemon-reload
systemctl restart twitch-shantifarm.service
```
