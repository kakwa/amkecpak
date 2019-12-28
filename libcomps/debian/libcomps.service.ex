[Unit]
Description=libcomps
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/libcomps
Type=forking
PIDFile=/var/run/libcomps/libcomps.pid
#User=libcomps
#Group=libcomps
ExecStart=/usr/bin/libcomps $OPTIONS -p /var/run/libcomps/libcomps.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
