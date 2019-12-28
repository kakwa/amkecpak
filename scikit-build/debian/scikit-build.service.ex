[Unit]
Description=scikit-build
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/scikit-build
Type=forking
PIDFile=/var/run/scikit-build/scikit-build.pid
#User=scikit-build
#Group=scikit-build
ExecStart=/usr/bin/scikit-build $OPTIONS -p /var/run/scikit-build/scikit-build.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
