# Vhost
Shell script to manage vhosts a local server for testing.

##Installation

```
sudo git clone https://github.com/sk8sta13/Vhost
sudo cp ./Vhost/vhost.sh /usr/bin/vhost
sudo chmod +x /usr/bin/vhost
```

##Use

Displaying help
`su vhost -help

Displays a list of vhosts created in test server.
`su vhost -list

Creates a vhost "site.local" pointing to "/var/www/site.local", if the "site.local" directory does not exist, it is created.
`su vhost -create site.local

Creates a vhost "test.local" pointing to "/var/www/tests", if the directory "tests" does not exist it is created.
`su vhost -create test.local /var/www/tests

Disable vhost "site.local"
`su vhost -disable site.local

Enables vhost "site.local"
`su vhost -enable site.local

Disable vhost "test.local" and exclude the directory "/var/www/tests"
`su vhost -delete site.local

##Comments

Tests were done in a vm with ubuntu server 14 with Apache.
