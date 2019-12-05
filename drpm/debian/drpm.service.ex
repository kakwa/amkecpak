[Unit]
Description=drpm
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/drpm
Type=forking
PIDFile=/var/run/drpm/drpm.pid
#User=drpm
#Group=drpm
ExecStart=/usr/bin/drpm $OPTIONS -p /var/run/drpm/drpm.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
