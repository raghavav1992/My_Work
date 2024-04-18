#!/bin/bash

# List of components/service to check and restart
# ex: mysql, tomcat, apache2, schedular-tomcat etc...

components=("service1" "service2" "service3")

# List of servers with SSH access
servers=("root@node1" "root@node2")


# Hazelcast node details, NodeIP, root user name, hazelcast home directory etc
# if you have multiple nodes, you need to add one more variable like 
# HAZEL_NODE1, HAZEL_NODE2 and do the script changes to read all the hazel nodes...

HAZEL_NODE="node_ip"
HAZEL_USER="root"
HAZELCAST_DIR="/opt/hazelcast-3.12.8/bin/"
LOG_DIR="/opt/hazelcast-3.12.8/logs/"
PID_FILE="${HAZELCAST_DIR}hazelcast_instance.pid"
START_SCRIPT="${HAZELCAST_DIR}start.sh > ${LOG_DIR}logs.out 2>&1 &"
STOP_SCRIPT="${HAZELCAST_DIR}stop.sh"

ssh_command="ssh $HAZEL_USER@$HAZEL_NODE"

# Check if pid file exists
$ssh_command "[ -f $PID_FILE ]"
PID_FILE_EXISTS=$?

if [ $PID_FILE_EXISTS -eq 0 ]; then
    # If pid file exists, stop the process
    echo "Starting Hazelcast Service_____"
    $ssh_command "$STOP_SCRIPT"
    echo "Successfully stopped Hazelcast..."
    sleep 10
else
    # If pid file does not exist, start the process
    echo "Starting Hazelcast Service_____"
fi
    $ssh_command "$START_SCRIPT"
    echo "Successfully started Hazelcast..."
    sleep 10

for server in "${servers[@]}"; do
    echo "Checking compnents on the servers"
    for component in "${components[@]}"; do
        # Check if the service is running in the server
        #if ssh $server "systemctl is-enabled $component.service" >/dev/null 2>&1; then
        if ssh $server "systemctl list-units --type=service | grep $component" >/dev/null 2>&1; then
           echo "$component.service is present on $server"
                        sudo ssh $server "service "$component" stop"
                        sleep 5
                        sudo ssh $server "service "$component" start"
            # Check if the service restarted successfully
            if [ $? -eq 0 ]; then
                echo "$component.service restarted successfully on $server"
            else
                echo "Failed to restart $component.service on $server"
            fi
        else
            echo "$component.service is not present on $server Checking for next componet"
        fi
    done

    echo "------------------------"
done