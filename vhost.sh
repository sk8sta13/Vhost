#!/bin/bash

case $1 in
	"-h")
		echo "Use: vhost.sh [option] [parameters]";
		echo "Valid options:";
		echo "  -c [url] [folder],	creates a vhost through the folder and the url, restart apache and exit";
		echo "  -l,			show a list of vhosts and exit";
		echo "  -h,			show this help and exit";
		echo "  -u [url],		enables site, restart apache and exit";
		echo "  -d [url],		disables site, restart apache and exit"
	;;
	"-l")
		for file_name in /etc/apache2/sites-available/*.conf; do
			i=0;
			h="";
			u="";
			while read line; do
				i=`expr $i + 1`
				if [ $i = 4 ]; then
					u=${line//ServerAlias /};
				fi
				if [ $i = 5 ]; then
					h=${line//DocumentRoot /};
				fi
			done < $file_name
			echo "$h -> $u";
		done
	;;
	"-c")
		if [ $# -ge 2 ]; then
			if [ $# = 2 ]; then
				folder="/var/www/$2";
			else
				folder=$3
			fi

			if [ ! -d $folder ]; then
				mkdir $folder
			fi

			se="/etc/apache2/sites-enabled/$2";
			sa="/etc/apache2/sites-available/$2";

			echo "<VirtualHost *:80>" >> $sa;
			echo "	ServerName $2" >> $sa;
			echo "	ServerAlias $2" >> $sa;
			echo "	DocumentRoot $folder" >> $sa;
			echo "	ErrorLog \${APACHE_LOG_DIR}/error.log" >> $sa;
			echo "	CustomLog \${APACHE_LOG_DIR}/access.log combined" >> $sa;
			echo "</VirtualHost>" >> $sa;

			ls -s $sa $se
			
			/etc/init.d/apache2 restart

			echo "vhost created, do not forget the add IP to you hosts"
		else
			echo "is lacking any argument."
		fi
	;;
	"-u")
		if [ $# -ge 2 ]; then
			se="/etc/apache2/sites-enabled/$2";
			sa="/etc/apache2/sites-available/$2";
			ls -s $sa $se
			/etc/init.d/apache2 restart
			echo "the site is enabled"
		fi
	;;
	"-d")
		if [ $# -ge 2 ]; then
			se="/etc/apache2/sites-enabled/$2";
			rm -r $se;
			/etc/init.d/apache2 restart
			echo "the site is disabled"
		fi
	;;
	*)
		echo "You must pass parameters, see the help before"
	;;
esac
