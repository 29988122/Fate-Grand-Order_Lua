
mount -rw -o remount /system
cp /sdcard/installBootDaemon.tmp/init.sh.org /sdcard/installBootDaemon.tmp/init.sh.new
echo "\nama_daemon\n" >> /sdcard/installBootDaemon.tmp/init.sh.new
#cp /sdcard/installBootDaemon.tmp/init.sh.new /system/etc/init.sh
#cp /system/etc/init.sh /sdcard/installBootDaemon.tmp/init.sh.modified
