echo -e "\e[35mDisable Default Version of NodeJS\e[0m"
dnf module disable nodejs -y

echo -e "\e[35mEnable NodeJS18 Version\e[0m"
dnf module enable nodejs:18 -y

echo -e "\e[35mInstall NodeJS\e[0m"
dnf install nodejs -y

echo -e "\e[35mConfigure Backend Service\e[0m"
cp backend.service /etc/systemd/system/backend.service

echo -e "\e[35mAdding Application User\e[0m"
useradd expense

echo -e "\e[35mRemove existing App content\e[0m"
rm -rf /app

echo -e "\e[35mCreate Application Directory\e[0m"
mkdir /app

echo -e "\e[35mDownload Application Content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app

echo -e "\e[35mExtracting Application Content\e[0m"
unzip /tmp/backend.zip

echo -e "\e[35mDownloading Application Dependencies\e[0m"
npm install

echo -e "\e[35mReloading SystemD and Start Backend Service\e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl restart backend

echo -e "\e[35mInstall MySQL Client\e[0m"
dnf install mysql -y

echo -e "\e[35mLoad Schema\e[0m"
mysql -h mysql-dev.rdevopsb73.online -uroot -pExpenseApp@1 < /app/schema/backend.sql

