LOG_FILE=/tmp/mysql

source common.sh

echo "Setting Up Mysql Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG-FILE
StatusCheck $?

echo "Disable Mysql Default Module to Enable 5.7 Mysql"
dnf module disable mysql -y &>>$LOG-FILE
StatusCheck $?
