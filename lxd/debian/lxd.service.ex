[Unit]
Description=lxd
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/lxd
Type=forking
PIDFile=/var/run/lxd/lxd.pid
#User=lxd
#Group=lxd
ExecStart=/usr/bin/lxd $OPTIONS -p /var/run/lxd/lxd.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
