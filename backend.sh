echo -e "\e[35mDisable Default Version of NodeJS\e[0m"
dnf module disable nodejs -y &>>/tmp/expense.log

echo -e "\e[35mEnable NodeJS18 Version\e[0m"
dnf module enable nodejs:18 -y &>>/tmp/expense.log

echo -e "\e[35mInstall NodeJS\e[0m"
dnf install nodejs -y &>>/tmp/expense.log

echo -e "\e[35mConfigure Backend Service\e[0m"
cp backend.service /etc/systemd/system/backend.service &>>/tmp/expense.log

echo -e "\e[35mAdding Application User\e[0m"
useradd expense &>>/tmp/expense.log

echo -e "\e[35mRemove existing App content\e[0m"
rm -rf /app &>>/tmp/expense.log

echo -e "\e[35mCreate Application Directory\e[0m"
mkdir /app &>>/tmp/expense.log

echo -e "\e[35mDownload Application Content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>/tmp/expense.log
cd /app

echo -e "\e[35mExtracting Application Content\e[0m"
unzip /tmp/backend.zip &>>/tmp/expense.log

echo -e "\e[35mDownloading Application Dependencies\e[0m"
npm install &>>/tmp/expense.log

echo -e "\e[35mReloading SystemD and Start Backend Service\e[0m"
systemctl daemon-reload &>>/tmp/expense.log
systemctl enable backend &>>/tmp/expense.log
systemctl restart backend &>>/tmp/expense.log

echo -e "\e[35mInstall MySQL Client\e[0m"
dnf install mysql -y &>>/tmp/expense.log

echo -e "\e[35mLoad Schema\e[0m"
mysql -h mysql-dev.rdevopsb73.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>/tmp/expense.log

