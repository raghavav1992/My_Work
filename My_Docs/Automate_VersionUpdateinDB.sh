#!/bin/bash

# MySQL credentials and connection details
DB_HOST="ci-qa-internal.csidkxjifsrh.us-east-1.rds.amazonaws.com"
DB_USER="root"
DB_PASSWORD="Ci$sw0rd&!2023#"
DB_NAME="ci_qa_sp44_auto"

# Table and content modification details
TABLE_NAME="fluidiam_config_properties"
COLUMN_NAME="config_value"
NEW_VALUE="v23.44.06.07"
CONDITION_COLUMN="config_key"
CONDITION_VALUE="cidversionnumber"

# Build the MySQL command
MYSQL_CMD="mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME}"

# Query to update table content
UPDATE_QUERY="UPDATE ${TABLE_NAME} SET ${COLUMN_NAME}='${NEW_VALUE}' WHERE ${CONDITION_COLUMN}='${CONDITION_VALUE}';"

# Execute the MySQL command
echo "Executing MySQL query..."
${MYSQL_CMD} -e "${UPDATE_QUERY}"

# Check for errors
if [ $? -eq 0 ]; then
  echo "Update successful."
else
  echo "Error: Unable to update table."
fi