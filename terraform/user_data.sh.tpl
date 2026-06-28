#!/bin/bash
set -euxo pipefail

APP_DIR="/home/ubuntu/project1"
APP_PORT="${app_port}"
LOG_GROUP_NAME="${log_group_name}"
AWS_REGION="${aws_region}"

apt-get update
apt-get install -y python3-full python3-venv python3-pip wget

mkdir -p "$APP_DIR" /var/log/flask-app
chown ubuntu:ubuntu "$APP_DIR" /var/log/flask-app

cat > "$APP_DIR/app.py" <<'APP_EOF'
${app_py_content}
APP_EOF

cat > "$APP_DIR/requirements.txt" <<'REQ_EOF'
${requirements_txt_content}
REQ_EOF

chown ubuntu:ubuntu "$APP_DIR/app.py" "$APP_DIR/requirements.txt"

sudo -u ubuntu python3 -m venv "$APP_DIR/venv"
sudo -u ubuntu "$APP_DIR/venv/bin/pip" install -r "$APP_DIR/requirements.txt"

cat > /etc/systemd/system/flask-app.service <<EOF
[Unit]
Description=Flask Cloud Workload Status Service
After=network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=$APP_DIR
Environment="PATH=$APP_DIR/venv/bin"
ExecStart=$APP_DIR/venv/bin/gunicorn -w 2 -b 0.0.0.0:$APP_PORT --access-logfile /var/log/flask-app/app.log --error-logfile /var/log/flask-app/app.log app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable flask-app
systemctl start flask-app

wget -q https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O /tmp/amazon-cloudwatch-agent.deb
dpkg -i /tmp/amazon-cloudwatch-agent.deb

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/flask-app/app.log",
            "log_group_name": "$LOG_GROUP_NAME",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s
