[Unit]
Description=mock-core-configs
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/mock-core-configs
Type=forking
PIDFile=/var/run/mock-core-configs/mock-core-configs.pid
#User=mock-core-configs
#Group=mock-core-configs
ExecStart=/usr/bin/mock-core-configs $OPTIONS -p /var/run/mock-core-configs/mock-core-configs.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
