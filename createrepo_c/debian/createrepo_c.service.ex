[Unit]
Description=createrepo_c
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/createrepo_c
Type=forking
PIDFile=/var/run/createrepo_c/createrepo_c.pid
#User=createrepo_c
#Group=createrepo_c
ExecStart=/usr/bin/createrepo_c $OPTIONS -p /var/run/createrepo_c/createrepo_c.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
