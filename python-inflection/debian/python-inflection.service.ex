[Unit]
Description=python-inflection
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/python-inflection
Type=forking
PIDFile=/var/run/python-inflection/python-inflection.pid
#User=python-inflection
#Group=python-inflection
ExecStart=/usr/bin/python-inflection $OPTIONS -p /var/run/python-inflection/python-inflection.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
