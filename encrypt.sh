#!/bin/bash

function encrypt {
	openssl rand -hex 64 > $encryptDir/key.$(date -Idate).bin
	openssl enc -aes-256-cbc -salt -in /backup/backup.$(date -Idate).tar.7z.xz -out /backup/backup.$(date -Idate).tar.7z.xz.enc -pass file:$encryptDir/key.$(date -Idate).bin
	openssl rsautl -encrypt -inkey $encryptDir/public_key.pem -pubin -in $encryptDir/key.$(date -Idate).bin -out $encryptDir/key.$(date -Idate).bin.enc
	rm $encryptDir/key.$(date -Idate).bin
	rm /backup/backup.$(date -Idate).tar.7z.xz
}

function decrypt {
	openssl rsautl -decrypt -inkey private_key.pem -in $a -out $a.decode
	openssl enc -d -aes-256-cbc -in $b -out $b.decode -pass file:./$a.decode
	rm $a.decode
}

if [ "$1" == "encrypt" ]; then
	encrypt
elif [ "$1" == "decrypt" ]; then
	a=$3
	b=$2
	if [ "$#" -ne 3 ]; then
		echo "Usage: ./encrypt.sh [encrypt/decrypt] <infile> <inkey>"
		exit 1
	fi
	decrypt
else
	echo "Usage: ./encrypt.sh [encrypt/decrypt] <infile> <inkey>"
fi

 
