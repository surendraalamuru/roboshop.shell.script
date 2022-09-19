LOG-FILE=/tmp/frontend

source common.sh

echo installing Nginx
yum install nginx -y
StatusCheck $?

echo Downloading Nginx web content  &>>LOG-FILE
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>LOG-FILE
StatusCheck $?

cd /usr/share/nginx/html

echo Removing web content
rm -rf * &>>/tmp/frontend
StatusCheck $?

echo Extracting web content
unzip /tmp/frontend.zip &>>LOG-FILE
StatusCheck $?

mv frontend-main/static/* . &>>LOG-FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>LOG-FILE

echo Starting Nginx Service
systemctl enable nginx &>>LOG-FILE
systemctl restart nginx &>>LOG-FILE
StatusCheck $?