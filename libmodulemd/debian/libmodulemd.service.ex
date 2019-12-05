[Unit]
Description=libmodulemd
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/libmodulemd
Type=forking
PIDFile=/var/run/libmodulemd/libmodulemd.pid
#User=libmodulemd
#Group=libmodulemd
ExecStart=/usr/bin/libmodulemd $OPTIONS -p /var/run/libmodulemd/libmodulemd.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
