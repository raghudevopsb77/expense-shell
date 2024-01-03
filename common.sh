log_file=/tmp/expense.log

Head() {
  echo -e "\e[35m$1\e[0m"
}

App_Prereq() {
  DIR=$1

  Head "Remove existing App content"
  rm -rf $1 &>>$log_file
  Stat $?

  Head "Create Application Directory"
  mkdir $1 &>>$log_file
  Stat $?

  Head "Download Application Content"
  curl -o /tmp/${component}.zip https://expense-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  Stat $?

  cd $1

  Head "Extracting Application Content"
  unzip /tmp/${component}.zip &>>$log_file
  Stat $?
}

Stat() {
  if [ "$1" -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    exit 1
  fi
}

