[Unit]
Description=mock
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/mock
Type=forking
PIDFile=/var/run/mock/mock.pid
#User=mock
#Group=mock
ExecStart=/usr/bin/mock $OPTIONS -p /var/run/mock/mock.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
