[Unit]
Description=python-slackclient
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/python-slackclient
Type=forking
PIDFile=/var/run/python-slackclient/python-slackclient.pid
#User=python-slackclient
#Group=python-slackclient
ExecStart=/usr/bin/python-slackclient $OPTIONS -p /var/run/python-slackclient/python-slackclient.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
