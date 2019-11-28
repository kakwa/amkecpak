[Unit]
Description=distribution-gpg-keys
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/distribution-gpg-keys
Type=forking
PIDFile=/var/run/distribution-gpg-keys/distribution-gpg-keys.pid
#User=distribution-gpg-keys
#Group=distribution-gpg-keys
ExecStart=/usr/bin/distribution-gpg-keys $OPTIONS -p /var/run/distribution-gpg-keys/distribution-gpg-keys.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
