[Unit]
Description=dnf-plugins-core
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/dnf-plugins-core
Type=forking
PIDFile=/var/run/dnf-plugins-core/dnf-plugins-core.pid
#User=dnf-plugins-core
#Group=dnf-plugins-core
ExecStart=/usr/bin/dnf-plugins-core $OPTIONS -p /var/run/dnf-plugins-core/dnf-plugins-core.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
