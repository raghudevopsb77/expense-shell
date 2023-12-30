MYSQL_PASSWORD=$1
log_file=/tmp/expense.log

Head() {
  echo -e "\e[35m$1\e[0m"
}


Head "Disable Default Version of NodeJS"
dnf module disable nodejs -y &>>$log_file

Head "Enable NodeJS18 Version"
dnf module enable nodejs:18 -y &>>$log_file

Head "Install NodeJS"
dnf install nodejs -y &>>$log_file

Head "Configure Backend Service"
cp backend.service /etc/systemd/system/backend.service &>>$log_file

Head "Adding Application User"
useradd expense &>>$log_file

Head "Remove existing App content"
rm -rf /app &>>$log_file

Head "Create Application Directory"
mkdir /app &>>$log_file

Head "Download Application Content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app

Head "Extracting Application Content"
unzip /tmp/backend.zip &>>$log_file

Head "Downloading Application Dependencies"
npm install &>>$log_file

Head "Reloading SystemD and Start Backend Service"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file

Head "Install MySQL Client"
dnf install mysql -y &>>$log_file

Head "Load Schema"
mysql -h mysql-dev.rdevopsb73.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file

