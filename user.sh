LOG_FILE=/tmp/user

source common.sh

echo "Setup NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
StatusCheck $?


echo "Install NodeJS"
yum install nodejs -y &>>${LOG_FILE}
StatusCheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
 echo "Add Roboshop application User"
 useradd roboshop &>>${LOG_FILE}
StatusCheck $?
fi

echo "Download User Application Code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "Clean old App Content"
rm -rf user &>>${LOG_FILE}
StatusCheck $?

echo "Extract User Application Code"
unzip -o /tmp/user.zip &>>${LOG_FILE}
StatusCheck $?

mv user-main user
cd /home/roboshop/user

echo "Install NodeJS Dependencies"
npm install &>>${LOG_FILE}
StatusCheck $?


echo "Update System Service File"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internsal/' /home/roboshop/user/systemd.service
StatusCheck $?

echo "Setup User Service"
  mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
StatusCheck $?

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable user &>>${LOG_FILE}

echo "Start User Service"
 systemctl start user &>>${LOG_FILE}
StatusCheck $?