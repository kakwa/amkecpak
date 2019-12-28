[Unit]
Description=dnf
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/dnf
Type=forking
PIDFile=/var/run/dnf/dnf.pid
#User=dnf
#Group=dnf
ExecStart=/usr/bin/dnf $OPTIONS -p /var/run/dnf/dnf.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
