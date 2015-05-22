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
				folder=$3
			fi

			if [ ! -d $folder ]; then
				mkdir $folder
			fi

			echo "<VirtualHost *:80>" >> $SA$2;
			echo "	ServerName $2" >> $SA$2;
			echo "	ServerAlias $2" >> $SA$2;
			echo "	DocumentRoot $folder" >> $SA$2;
			echo "	ErrorLog \${APACHE_LOG_DIR}/error.log" >> $SA$2;
			echo "	CustomLog \${APACHE_LOG_DIR}/access.log combined" >> $SA$2;
			echo "</VirtualHost>" >> $SA$2;

			ln -s $SA$2 $SE$2
			
			/etc/init.d/apache2 restart

			echo "vhost created, do not forget the add IP to you hosts"
		else
			echo "is lacking any argument."
		fi
	;;
	"-enable")
		if [ $# -ge 2 ]; then
			ln -s $SA$2 $SE$2
			/etc/init.d/apache2 restart
			echo "the site is enabled"
		fi
	;;
	"-disable")
		if [ $# -ge 2 ]; then
			rm $SE$2;
			/etc/init.d/apache2 restart
			echo "the site is disabled"
		fi
	;;
	"-delete")
		if [ $# -ge 2 ]; then
			path=$(grep "DocumentRoot" $SA$2)
			path=${path//	DocumentRoot /}
			rm $SA$2
			rm $SE$2
			rm -r $path
			/etc/init.d/apache2 restart
			echo "the host deleted"
		fi
	;;
	*)
		echo "You must pass parameters, see the help before"
	;;
esac
