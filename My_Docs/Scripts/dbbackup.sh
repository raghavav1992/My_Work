#!/bin/bash

# Backup storage directory 
backupfolder=/Backup/DB_Backup

# Notification email address 
recipient_email=CIDevOps@ilantus.com

# MySQL user
user=root

# MySQL password
password=Pa$$w0rd#9!$

#db endpoint
dbendpoint=pre-prod2-demo.csidkxjifsrh.us-east-1.rds.amazonaws.com

# Number of days to store the backup 
keep_day=1

sqlfile=$backupfolder/cid_demo_37-$(date +%d-%m-%Y_%H-%M-%S).sql
zipfile=$backupfolder/cid_demo_37-$(date +%d-%m-%Y_%H-%M-%S).zip 

# Create a backup 
mysqldump -u $user -p$password -h $dbendpoint cid_demo_37 > $sqlfile 

if [ $? == 0 ]; then
  echo 'Sql dump created' 
else
  echo 'mysqldump return non-zero code' | mailx -s 'No backup was created!' $recipient_email  
  exit 
fi 

# Compress backup 
zip $zipfile $sqlfile 
if [ $? == 0 ]; then
  echo 'The backup was successfully compressed' 
else
  echo 'Error compressing backup' | mailx -s 'Backup was not created!' $recipient_email 
  exit 
fi 
rm $sqlfile 
echo $zipfile | mailx -s 'Backup was successfully created' $recipient_email 

# Delete old backups 
find $backupfolder -mtime +$keep_day -delete
