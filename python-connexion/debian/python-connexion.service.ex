[Unit]
Description=python-connexion
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/python-connexion
Type=forking
PIDFile=/var/run/python-connexion/python-connexion.pid
#User=python-connexion
#Group=python-connexion
ExecStart=/usr/bin/python-connexion $OPTIONS -p /var/run/python-connexion/python-connexion.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
