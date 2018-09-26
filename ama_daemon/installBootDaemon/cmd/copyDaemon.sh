mount -rw -o remount /system
cp /sdcard/installBootDaemon.tmp/ama_daemon /system/bin/ama_daemon
#cp /system/etc/init.nox.sh /sdcard/installBootDaemon.tmp/init.nox.sh.org

chmod 755 /system/bin/ama_daemon

find /system -name "init*sh" > /sdcard/installBootDaemon.tmp/log
