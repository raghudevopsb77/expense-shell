source common.sh

Head "Install Nginx"
dnf install nginx -y &>>$log_file
echo $?

Head "Copy Expense Config File"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
echo $?

Head "Remove Old/Default Content"
rm -rf /usr/share/nginx/html/* &>>$log_file
echo $?

Head "Download Application Code"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
echo $?

cd /usr/share/nginx/html

Head "Extract Application Code"
unzip /tmp/frontend.zip &>>$log_file
echo $?

Head "Start Nginx Service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
echo $?

