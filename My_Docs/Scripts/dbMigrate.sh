#!/bin/bash
SRC_DB_HOST="ilantus-cid-prod-mum.cl37ev7plcdv.ap-south-1.rds.amazonaws.com"
SRC_DB_PORT="3306"
SRC_DB_USER="crossid_admin"
TARGET_DB_HOST="crossid-fivestar-prod.cl37ev7plcdv.ap-south-1.rds.amazonaws.com"
TAEGET_DB_PORT="3306"
TARGET_DB_USER="crossid_admin"
DB_PASSWORD="Cross#c!d$admin"


echo "###################################################"
echo "INFO: Taking dump of cid_audit_prod_mumbai database"
echo "###################################################"
mysqldump --lock-tables=false -h ${SRC_DB_HOST} -P ${SRC_DB_PORT} -u ${SRC_DB_USER} --password=${DB_PASSWORD} cid_audit_prod_mumbai > ./cid_audit_prod_mumbai.sql
echo "INFO: Dump of cid_audit_prod_mumbai database taken successfully"

echo "############################################################"
echo "INFO: Restoring cid_audit_prod_mumbai database in Target DB"
echo "############################################################"
mysql -h ${TARGET_DB_HOST} -P ${TAEGET_DB_PORT} -u ${TARGET_DB_USER} --password=${DB_PASSWORD} -f -D cid_audit_prod_mumbai < ./cid_audit_prod_mumbai.sql
echo "INFO: cid_audit_prod_mumbai database restored successfully in UAT DB"



echo "###################################################"
echo "INFO: Taking dump of crossid_prod_mumbai database"
echo "###################################################"
mysqldump --lock-tables=false -h ${SRC_DB_HOST} -P ${SRC_DB_PORT} -u ${SRC_DB_USER} --password=${DB_PASSWORD} crossid_prod_mumbai > ./crossid_prod_mumbai.sql
echo "INFO: Dump of crossid_prod_mumbai database taken successfully"

echo "############################################################"
echo "INFO: Restoring crossid_prod_mumbai database in Target DB"
echo "############################################################"
mysql -h ${TARGET_DB_HOST} -P ${TAEGET_DB_PORT} -u ${TARGET_DB_USER} --password=${DB_PASSWORD} -f -D crossid_prod_mumbai < ./crossid_prod_mumbai.sql
echo "INFO: wrench crossid_prod_mumbai restored successfully in UAT DB"