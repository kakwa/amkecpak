[Unit]
Description=@@COMPONENT_NAME@@
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/@@COMPONENT_NAME@@
Type=forking
PIDFile=/var/run/@@COMPONENT_NAME@@/@@COMPONENT_NAME@@.pid
#User=@@COMPONENT_NAME@@
#Group=@@COMPONENT_NAME@@
ExecStart=/usr/bin/@@COMPONENT_NAME@@ $OPTIONS -p /var/run/@@COMPONENT_NAME@@/@@COMPONENT_NAME@@.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
