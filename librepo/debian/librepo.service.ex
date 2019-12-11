[Unit]
Description=librepo
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/librepo
Type=forking
PIDFile=/var/run/librepo/librepo.pid
#User=librepo
#Group=librepo
ExecStart=/usr/bin/librepo $OPTIONS -p /var/run/librepo/librepo.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
