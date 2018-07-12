[Unit]
Description=pagure
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/pagure
Type=forking
PIDFile=/var/run/pagure/pagure.pid
#User=pagure
#Group=pagure
ExecStart=/usr/bin/pagure $OPTIONS -p /var/run/pagure/pagure.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
