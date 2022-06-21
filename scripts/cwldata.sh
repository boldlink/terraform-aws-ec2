#!/bin/bash

DEBUG=$${DEBUG:=off}

if [ $${DEBUG} == 'on' ]; then
    set -x
fi

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id | cut -d "-" -f 2)
ami_architecture=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document/ | jq  -r ".architecture")
az=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
region="$${az::-1}"
log_group="${log_group}"

###########################################
# Install/configure cloudwatch logs agent #
###########################################
systemctl enable awslogsd.service
systemctl stop awslogsd


mv /etc/awslogs/awslogs.conf{,.old}
mv /etc/awslogs/awscli.conf{,.old}

cat <<EOF >/etc/awslogs/awscli.conf
[plugins]
cwlogs = cwlogs
[default]
region = $${region}
EOF

cat <<EOF >/etc/awslogs/awslogs.conf
[general]
state_file = /etc/awslogs/agent-state

[/var/log/awslogs.log.log]
file = /var/log/awslogs.log
log_group_name = ${log_group}
log_stream_name = {instance_id}/awslogs

[/var/log/cron]
file = /var/log/cron
log_group_name = ${log_group}
log_stream_name = {instance_id}/cron

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${log_group}
log_stream_name = {instance_id}/dmesg

[/var/log/messages]
file = /var/log/messages
log_group_name = ${log_group}
log_stream_name = {instance_id}/messages
datetime_format = %b %d %H:%M:%S

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log.*
log_group_name = ${log_group}
log_stream_name = {instance_id}/audit
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/secure]
file = /var/log/secure*
log_group_name = ${log_group}
log_stream_name = {instance_id}/secure
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/cloud-init.log]
file = /var/log/cloud-init.log*
log_group_name = ${log_group}
log_stream_name = {instance_id}/cloud-init.log
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/cloud-init-output.log]
file = /var/log/cloud-init-output.log*
log_group_name = ${log_group}
log_stream_name = {instance_id}/cloud-init-output.log
datetime_format = %Y-%m-%dT%H:%M:%SZ
EOF

# Enable Cloudwatch agent advanced metrics

yum -y install amazon-cloudwatch-agent

cat <<EOF >./awslogs.json
{
    "agent": {
        "metrics_collection_interval": 10,
        "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
    },
    "metrics": {
        "metrics_collected": {
            "cpu": {
                "resources": [
                    "*"
                ],
                "measurement": [
                    "usage_idle",
                    "usage_iowait",
                    "usage_system",
                    "usage_user"
                ],
                "totalcpu": false,
                "metrics_collection_interval": 10
            },
            "disk": {
                "resources": [
                    "*"
                ],
                "measurement": [
                    "free",
                    "total",
                    "used",
                    "used_percent"
                ],
                "ignore_file_system_types": [
                    "sysfs",
                    "devtmpfs"
                ],
                "metrics_collection_interval": 60
            },
            "diskio": {
                "resources": [
                    "*"
                ],
                "measurement": [
                    "reads",
                    "writes",
                    "read_bytes",
                    "write_bytes",
                    "read_time",
                    "write_time",
                    "io_time",
                    "iops_in_progress"
                ],
                "metrics_collection_interval": 10
            },
            "swap": {
                "measurement": [
                    "free",
                    "used",
                    "used_percent"
                ]
            },
            "mem": {
                "measurement": [
                    "active",
                    "available",
                    "available_percent",
                    "inactive",
                    "total",
                    "used",
                    "used_percent"
                ],
                "metrics_collection_interval": 10
            },
            "net": {
                "resources": [
                    "*"
                ],
                "measurement": [
                    "bytes_sent",
                    "bytes_recv",
                    "drop_in",
                    "drop_out"
                ]
            },
            "netstat": {
                "measurement": [
                    "tcp_established",
                    "tcp_time_wait"
                ],
                "metrics_collection_interval": 10
            },
            "processes": {
                "measurement": [
                    "idle",
                    "running",
                    "stopped",
                    "total"
                ]
            }
        },
        "append_dimensions": {
            "ImageId": "$${aws:ImageId}",
            "InstanceId": "$${aws:InstanceId}",
            "InstanceType": "$${aws:InstanceType}",
            "AutoScalingGroupName": "$${aws:AutoScalingGroupName}"
        },
        "aggregation_dimensions": [
            [
                "ImageId"
            ],
            [
                "InstanceId",
                "InstanceType"
            ],
            []
        ]
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
                        "log_group_name": "${log_group}",
                        "log_stream_name": "$${aws:InstanceId}/amazon-cloudwatch-agent.log",
                        "timezone": "Local"
                    }
                ]
            }
        },
        "log_stream_name": "$${aws:InstanceId}/amazon-cloudwatch-agent.log"
    }
}
EOF


/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:./awslogs.json -s

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -m auto -c default

systemctl start awslogsd
