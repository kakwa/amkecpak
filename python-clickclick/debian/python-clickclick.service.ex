[Unit]
Description=python-clickclick
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/python-clickclick
Type=forking
PIDFile=/var/run/python-clickclick/python-clickclick.pid
#User=python-clickclick
#Group=python-clickclick
ExecStart=/usr/bin/python-clickclick $OPTIONS -p /var/run/python-clickclick/python-clickclick.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
