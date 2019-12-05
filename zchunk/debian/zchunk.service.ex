[Unit]
Description=zchunk
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/zchunk
Type=forking
PIDFile=/var/run/zchunk/zchunk.pid
#User=zchunk
#Group=zchunk
ExecStart=/usr/bin/zchunk $OPTIONS -p /var/run/zchunk/zchunk.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
