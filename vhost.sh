#!/bin/bash

SA="/etc/apache2/sites-available/";
SE="/etc/apache2/sites-enabled/";

case $1 in
	"-help")
		echo "Use: vhost.sh [option] [parameters]";
		echo "Valid options:";
		echo "  -create [url] [folder],	creates a vhost through the folder and the url, restart apache and exit";
		echo "  -list,			show a list of vhosts and exit";
		echo "  -help,			show this help and exit";
		echo "  -enable [url],		enables site, restart apache and exit";
		echo "  -disable [url],		disables site, restart apache and exit"
		echo "  -delete [url],		disables site and delete all files"
	;;
	"-list")
		for file_name in $SA*; do
			if [ -e ${file_name//-available/-enabled} ]; then
				stat="enabled";
			else
				stat="disabled";
			fi

			url=$(grep "ServerAlias" $file_name)
			url=${url//	ServerAlias /}

			path=$(grep "DocumentRoot" $file_name)
			path=${path//	DocumentRoot /}

			echo "$url	$stat -> $path"
		done
	;;
	"-create")
		if [ $# -ge 2 ]; then
			if [ $# = 2 ]; then
				folder="/var/www/$2";
			else
				folder=$3;
			fi

			if [ ! -d $folder ]; then
				mkdir $folder
			fi

			SAC="$SA$2.conf";
			SEC="$SE$2.conf";

			echo "<VirtualHost *:80>" >> $SAC;
			echo "	ServerName $2" >> $SAC;
			echo "	ServerAlias $2" >> $SAC;
			echo "	DocumentRoot $folder" >> $SAC;
			echo "	ErrorLog \${APACHE_LOG_DIR}/error.log" >> $SAC;
			echo "	CustomLog \${APACHE_LOG_DIR}/access.log combined" >> $SAC;
			echo "</VirtualHost>" >> $SAC;

			ln -s $SAC $SEC
			
			/etc/init.d/apache2 restart

			echo "vhost created, do not forget the add IP to you hosts"
		else
			echo "is lacking any argument."
		fi
	;;
	"-enable")
		if [ $# -ge 2 ]; then
			SAC="$SA$2.conf"
			SEC="$SA$2.conf"
			ln -s $SAC $SEC
			/etc/init.d/apache2 restart
			echo "the site is enabled"
		else
			echo "is lacking any argument."
		fi
	;;
	"-disable")
		if [ $# -ge 2 ]; then
			rm "$SE$2.conf";
			/etc/init.d/apache2 restart
			echo "the site is disabled"
		else
			echo "is lacking any argument."
		fi
	;;
	"-delete")
		if [ $# -ge 2 ]; then
			path=$(grep "DocumentRoot" $SA$2)
			path=${path//	DocumentRoot /}
			rm "$SA$2.conf"
			rm "$SE$2.conf"
			rm -r $path
			/etc/init.d/apache2 restart
			echo "the host deleted"
		else
			echo "is lacking any argument."
		fi
	;;
	*)
		echo "You must pass parameters, see the help before"
	;;
esac
