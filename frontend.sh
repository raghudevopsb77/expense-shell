component=frontend
source common.sh

Head "Install Nginx"
dnf install nginx -y &>>$log_file
echo $?

Head "Copy Expense Config File"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
echo $?

App_Prereq "/usr/share/nginx/html"

Head "Start Nginx Service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
echo $?

