#!/bin/bash
TARC=$(find /backup -name *.tar -exec echo 1 \;)
SZC=$(find /backup -name *.tar.7z -exec echo 1 \;)
XZC=$(find /backup -name *.tar.7z.xz -exec echo 1 \;)
name=backup.$(date -Idate).tar
echo "Creating Backup for: " $name
#echo "Tar: " $TARC
#echo "7z: " $SZC
#echo "xz: " $XZC
if [ -z "$TARC" ]; then
	if [ -z "$SZC" ]; then
		if [ -z "$XZC" ]; then
			tar -cvf /backup/$name /root /home /android
			7z -mx=9 -m0=lzma -mfb=64 -md=32m -ms=on a /backup/$name.7z /backup/$name
			rm /backup/$name
			xz -T 0 -v -z /backup/$name.7z
			$encryptDir/encrypt.sh encrypt
		else
			$encryptDir/encrypt.sh encrypt
		fi
	else
		xz -T 0 -v -z /backup/$name.7z
		$encryptDir/encrypt.sh encrypt
	fi
else
	7z -mx=9 -m0=lzma -mfb=64 -md=32m -ms=on a /backup/$name.7z /backup/$name
	rm /backup/$name	
 	xz -T 0 -v -z /backup/$name.7z
	$encryptDir/encrypt/encrypt.sh encrypt
fi
echo "Putting"
sftp -b ./cmd.bat $bakupServer
i=$(ls -1 /backup | wc -l)
