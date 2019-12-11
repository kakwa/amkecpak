[Unit]
Description=libdnf
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/libdnf
Type=forking
PIDFile=/var/run/libdnf/libdnf.pid
#User=libdnf
#Group=libdnf
ExecStart=/usr/bin/libdnf $OPTIONS -p /var/run/libdnf/libdnf.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
