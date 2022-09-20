LOG_FILE=/tmp/mysql

source common.sh

echo "Setting Up Mysql Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
StatusCheck $?

echo "Disable Mysql Default Module to Enable 5.7 Mysql"
dnf module disable mysql -y &>>$LOG_FILE
StatusCheck $?

echo "Install Mysql"
yum install mysql-community-server -y  &>>$LOG_FILE
StatusCheck $?

echo "Start Mysql Service"
systemctl enable mysqld  &>>$LOG_FILE
systemctl start mysqld  &>>$LOG_FILE
StatusCheck $?

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${ROBOSHOP_MYSQL_PASSWORD}');
FLUSH PRIVILEGES;" >/tmp/root-pass.sql

echo "Change the default root password"
mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/root-pass.sql &>>$LOG_FILE
StatusCheck $?