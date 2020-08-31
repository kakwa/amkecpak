[Unit]
Description=snes9x
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/snes9x
Type=forking
PIDFile=/var/run/snes9x/snes9x.pid
#User=snes9x
#Group=snes9x
ExecStart=/usr/bin/snes9x $OPTIONS -p /var/run/snes9x/snes9x.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
