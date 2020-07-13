#!/bin/bash
# Thanks to https://gist.github.com/Mins/4602864
# Script tested on mysql Ver 15.1 Distrib 5.5.64-MariaDB

# Install Expect
yum -y install expect

# Check if mariadb is started
systemctl status mariadb

# Start mariadb if it is not running
if [[ ${?} -ne '0' ]]
then
    echo "starting mariadb"
    systemctl start mariadb
fi

# Set Root Password Here - Migrate to Ansible Vault
MYSQL_ROOT_PASSWORD=dbAdminPassword

# Run mysql_secure_installation

SECURE_MYSQL=$(expect -c "

set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"\r\"

expect \"Set root password?\"
send \"Y\r\"

expect \"New password:\"
send \"$MYSQL_ROOT_PASSWORD\r\"

expect \"Re-enter new password:\"
send \"$MYSQL_ROOT_PASSWORD\r\"

expect \"Remove anonymous users?\"
send \"Y\r\"

expect \"Disallow root login remotely?\"
send \"Y\r\"

expect \"Remove test database and access to it?\"
send \"Y\r\"

expect \"Reload privilege tables now?\"
send \"Y\r\"

expect eof
")

echo "$SECURE_MYSQL"

yum -y remove expect
