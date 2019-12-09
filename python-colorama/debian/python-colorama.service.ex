[Unit]
Description=python-colorama
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/python-colorama
Type=forking
PIDFile=/var/run/python-colorama/python-colorama.pid
#User=python-colorama
#Group=python-colorama
ExecStart=/usr/bin/python-colorama $OPTIONS -p /var/run/python-colorama/python-colorama.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
