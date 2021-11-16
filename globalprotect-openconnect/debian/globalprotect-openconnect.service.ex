[Unit]
Description=globalprotect-openconnect
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/globalprotect-openconnect
Type=forking
PIDFile=/var/run/globalprotect-openconnect/globalprotect-openconnect.pid
#User=globalprotect-openconnect
#Group=globalprotect-openconnect
ExecStart=/usr/bin/globalprotect-openconnect $OPTIONS -p /var/run/globalprotect-openconnect/globalprotect-openconnect.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
