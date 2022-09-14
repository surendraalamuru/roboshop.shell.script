echo installing Nginx
yum install nginx -y

echo Downloading Nginx web content  &>>/tmp/frontend
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend

cd /usr/share/nginx/html

echo Removing web content
rm -rf * &>>/tmp/frontend

echo Extracting web content
unzip /tmp/frontend.zip &>>/tmp/frontend


mv frontend-main/static/* . &>>/tmp/frontend
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/frontend

echo Starting Nginx Service
systemctl enable nginx &>>/tmp/frontend
systemctl restart nginx &>>/tmp/frontend