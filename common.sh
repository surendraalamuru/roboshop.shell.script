ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this script as root user or with sudo privileges.
  exit 1
fi

StatusCheck() {
  if [ $1 -eq 0 ]; then
    echo -e Status = "\e[32mSUCCESS\e[0m"
  else
    echo -e Status = "\e[31mFAILURE\e[0m"
    exit 1
  fi
}

APP_PREREQ() {

  id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
   echo "Add Roboshop application User"
   useradd roboshop &>>${LOG_FILE}
  StatusCheck $?
  fi

  echo "Download${COMPONENT} Application Code"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  StatusCheck $?

  cd /home/roboshop

  echo "Clean old App Content"
  rm -rf ${COMPONENT} &>>${LOG_FILE}
  StatusCheck $?

  echo "Extract ${COMPONENT} Application Code"
  unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE}
  StatusCheck $?

  mv ${COMPONENT}-main ${COMPONENT}
  cd /home/roboshop/user

}
SYSTEMD_SETUP() {
  echo "Update System Service File"
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internsal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CART_ENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
  StatusCheck $?

  echo "Setup ${COMPONENT} Service"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
  StatusCheck $?

  systemctl daemon-reload &>>${LOG_FILE}
  systemctl enable ${COMPONENT} &>>${LOG_FILE}

  echo "Start ${COMPONENT} Service"
   systemctl start ${COMPONENT}yum &>>${LOG_FILE}
  StatusCheck $?
}
NODEJS() {

echo "Setup NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
StatusCheck $?


echo "Install NodeJS"
yum install nodejs -y &>>${LOG_FILE}
StatusCheck $?

APP_PREREQ

echo "Install NodeJS Dependencies"
npm install &>>${LOG_FILE}
StatusCheck $?

SYSTEMD_SETUP

}

JAVA() {
  echo "Install Maven"
  yum install maven -y &>>${LOG_FILE}
  StatusCheck $?

  APP_PREREQ

  echo "Download Dependencies and Make Package"
  mvn clean package &>>${LOG_FILE}
  mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar  &>>${LOG_FILE}
  StatusCheck $?

  SYSTEMD_SETUP

}