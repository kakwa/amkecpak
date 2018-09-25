[Unit]
Description=python-swagger-spec-validator
After=network.target
Wants=network.service

[Service]
EnvironmentFile=/etc/default/python-swagger-spec-validator
Type=forking
PIDFile=/var/run/python-swagger-spec-validator/python-swagger-spec-validator.pid
#User=python-swagger-spec-validator
#Group=python-swagger-spec-validator
ExecStart=/usr/bin/python-swagger-spec-validator $OPTIONS -p /var/run/python-swagger-spec-validator/python-swagger-spec-validator.pid
KillMode=process
Restart=no

[Install]
WantedBy=multi-user.target
