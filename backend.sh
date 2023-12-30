MYSQL_PASSWORD=$1
log_file=/tmp/expense.log
echo -e "\e[35mDisable Default Version of NodeJS\e[0m"
dnf module disable nodejs -y &>>$log_file

echo -e "\e[35mEnable NodeJS18 Version\e[0m"
dnf module enable nodejs:18 -y &>>$log_file

echo -e "\e[35mInstall NodeJS\e[0m"
dnf install nodejs -y &>>$log_file

echo -e "\e[35mConfigure Backend Service\e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file

echo -e "\e[35mAdding Application User\e[0m"
useradd expense &>>$log_file

echo -e "\e[35mRemove existing App content\e[0m"
rm -rf /app &>>$log_file

echo -e "\e[35mCreate Application Directory\e[0m"
mkdir /app &>>$log_file

echo -e "\e[35mDownload Application Content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app

echo -e "\e[35mExtracting Application Content\e[0m"
unzip /tmp/backend.zip &>>$log_file

echo -e "\e[35mDownloading Application Dependencies\e[0m"
npm install &>>$log_file

echo -e "\e[35mReloading SystemD and Start Backend Service\e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file

echo -e "\e[35mInstall MySQL Client\e[0m"
dnf install mysql -y &>>$log_file

echo -e "\e[35mLoad Schema\e[0m"
mysql -h mysql-dev.rdevopsb73.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file

