#!/bin/bash
#author:max
#date:2018/08/31
#description:this bash will listen core service.
#include:nginx,php

PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
export PATH

date=$(date +%Y-%m-%d);
time=$(date +%Y/%m/%d-%H:%M:%S);

# log info
dir_path=/tmp/myBashLog/
file_path=${date}.log
full_path=${dir_path}${file_path}

test -d ${dir_path} || mkdir ${dir_path};
test -f ${full_path} || touch ${full_path};

nginx_status=$(systemctl status nginx | grep active | awk '{if(NR==1){print $2}}')
php_status=$(systemctl status php-fpm | grep active | awk '{if(NR==1){print $2}}')

# warning info
warning_code=0
warning_email_file=${dir_path}email.log
test -f ${warning_email_file} || touch ${warning_email_file}
echo '' > ${warning_email_file}

if [ "${nginx_status}" != "active" ]; then
    echo "${time} nginx is not running" >> ${full_path};
    warning_code=1
    systemctl status nginx >> ${warning_email_file}
else
    echo "${time} nginx is running" >> ${full_path};
fi

if [ "${php_status}" != "active" ]; then
    echo "${time} php is not running" >> ${full_path};
    warning_code=1
    systemctl status php-fpm >> ${warning_email_file}
else
    echo "${time} php is running" >> ${full_path};
fi

# send warning mail
if [ "${warning_code}" == 1 ]; then
    mail -s 'warning email' max_workspace@163.com < ${warning_email_file}
fi
