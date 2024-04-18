#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="cwagent installer"
TITLE="cwagent setup"
MENU="Choose one of the following options:"

OPTIONS=(1 "setup tomcat log monitoring"
         2 "setup system metric monitoring"
         3 "setup tomcat log & system metric monitoring"
         4 "cancel")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
echo "enter tomcat logfile path"
read file_path
echo "enter log group name"
read log_group_name
cd /opt
apt remove -y amazon-cloudwatch-agent
rm -rf aws/
rm -f amazon-cloudwatch-agent.*
ls
wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
cat <<EOF >/opt/aws/amazon-cloudwatch-agent/bin/config.json
{
	"agent": {
		"metrics_collection_interval": 60,
		"run_as_user": "root"
	},
	"logs": {
		"logs_collected": {
			"files": {
				"collect_list": [{
						"file_path": "$file_path/logs/catalina.out",
						"log_group_name": "$log_group_name",
						"log_stream_name": "{instance_id}/catalina-log"
					},
					{
						"file_path": "$file_path/logs/localhost.*.log",
						"log_group_name": "$log_group_name",
						"log_stream_name": "{instance_id}/localhost-log"
					}
				]
			}
		}
	}
}
EOF
touch /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
systemctl start amazon-cloudwatch-agent.service
systemctl status amazon-cloudwatch-agent.service
            ;;
        2)
cd /opt
apt remove -y amazon-cloudwatch-agent
rm -rf aws/
rm -f amazon-cloudwatch-agent.*
ls
wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
cat <<EOF >/opt/aws/amazon-cloudwatch-agent/bin/config.json
{
	"agent": {
		"metrics_collection_interval": 60,
		"run_as_user": "root"
	},
	"metrics": {
		"append_dimensions": {
			"AutoScalingGroupName": "\${aws:AutoScalingGroupName}",
			"ImageId": "\${aws:ImageId}",
			"InstanceId": "\${aws:InstanceId}",
			"InstanceType": "\${aws:InstanceType}"
		},
		"metrics_collected": {
			"cpu": {
				"resources": [
					"*"
				],
				"measurement": [{
						"name": "cpu_usage_idle",
						"rename": "CPU_USAGE_IDLE",
						"unit": "Percent"
					},
					{
						"name": "cpu_usage_nice",
						"unit": "Percent"
					},
					"cpu_usage_guest"
				],
				"totalcpu": false,
				"metrics_collection_interval": 10
			},
			"disk": {
				"measurement": [
					"used_percent"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"/"
				]
			},
			"mem": {
				"measurement": [
					"mem_used_percent"
				],
				"metrics_collection_interval": 60
			},
			"statsd": {
				"metrics_aggregation_interval": 60,
				"metrics_collection_interval": 10,
				"service_address": ":8125"
			}
		}
	}
}
EOF
touch /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
systemctl start amazon-cloudwatch-agent.service
systemctl status amazon-cloudwatch-agent.service
            ;;
        3)
echo "enter tomcat logfile path"
read file_path
echo "enter log group name"
read log_group_name
cd /opt
apt remove -y amazon-cloudwatch-agent
rm -rf aws/
rm -f amazon-cloudwatch-agent.*
ls
wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb            
cat <<EOF >/opt/aws/amazon-cloudwatch-agent/bin/config.json
{
        "agent": {
           "metrics_collection_interval": 60,
           "run_as_user": "root"
        },
        "logs": {
           "logs_collected": {
                "files": {
                        "collect_list": [
                                {
                                        "file_path": "$file_path/logs/catalina.out",
                                        "log_group_name": "$log_group_name",
                                        "log_stream_name": "{instance_id}/catalina-log"
                                },
                                {
                                        "file_path": "$file_path/logs/localhost.*.log",
                                        "log_group_name": "$log_group_name",
                                        "log_stream_name": "{instance_id}/localhost-log"
                                }
                        ]
                }
           }
        },
        "metrics": {
           "append_dimensions": {
                "AutoScalingGroupName": "\${aws:AutoScalingGroupName}",
                "ImageId": "\${aws:ImageId}",
                "InstanceId": "\${aws:InstanceId}",
                "InstanceType": "\${aws:InstanceType}"
           },
           "metrics_collected": {
                        "cpu": {
                "resources": [
                  "*"
                        ],
                "measurement": [
                  {"name": "cpu_usage_idle", "rename": "CPU_USAGE_IDLE", "unit": "Percent"},
                  {"name": "cpu_usage_nice", "unit": "Percent"},
                  "cpu_usage_guest"
                ],
                  "totalcpu": false,
                        "metrics_collection_interval": 10
                },
                "disk": {
                        "measurement": [
                                "used_percent"
                        ],
                        "metrics_collection_interval": 60,
                        "resources": [
                                "*"
                        ]
                },
                "mem": {
                        "measurement": [
                                "mem_used_percent"
                        ],
                        "metrics_collection_interval": 60
                },
                "statsd": {
                        "metrics_aggregation_interval": 60,
                        "metrics_collection_interval": 10,
                        "service_address": ":8125"
                }
           }
        }
}
EOF
touch /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
systemctl start amazon-cloudwatch-agent.service
systemctl status amazon-cloudwatch-agent.service
            ;;
        4)
            exit
            ;;
esac