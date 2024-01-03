MYSQL_PASSWORD=$1
if [ -z "$MYSQL_PASSWORD" ]; then
  echo Input MYSQL_PASSWORD is missing
  exit 1
fi
component=backend

source common.sh

Head "Disable Default Version of NodeJS"
dnf module disable nodejs -y &>>$log_file
Stat $?

Head "Enable NodeJS18 Version"
dnf module enable nodejs:18 -y &>>$log_file
Stat $?

Head "Install NodeJS"
dnf install nodejs -y &>>$log_file
Stat $?

Head "Configure Backend Service"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
Stat $?

Head "Adding Application User"
id expense &>>$log_file
if [ "$?" -ne 0 ]; then
  useradd expense &>>$log_file
fi
Stat $?

App_Prereq "/app"

Head "Downloading Application Dependencies"
npm install &>>$log_file
Stat $?

Head "Reloading SystemD and Start Backend Service"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
Stat $?

Head "Install MySQL Client"
dnf install mysql -y &>>$log_file
Stat $?

Head "Load Schema"
mysql -h mysql-dev.rdevopsb73.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file
Stat $?

