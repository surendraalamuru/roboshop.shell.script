LOG_FILE=/tmp/catalogue

echo "Setup NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE
fi


echo "Install NodeJS"
yum install nodejs -y &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE


echo "Add Roboshop application User"
useradd roboshop &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE


Echo "Download Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE


cd /home/roboshop

echo "Extract Catalogue Application Code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE


mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJS Dependencies"
 npm install &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE


 ECHO "Setup Catalogue Service"
  mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo Status = SUCCESS
else
  echo Status = FAILURE


systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}

echo "Start Catalogue Service"
 systemctl start catalogue &>>${LOG_FILE}
 if [ $? -eq 0 ]; then
   echo Status = SUCCESS
 else
   echo Status = FAILURE
