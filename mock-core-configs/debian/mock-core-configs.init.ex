#! /bin/sh

### BEGIN INIT INFO
# Provides:        mock-core-configs
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    mock-core-configs
### END INIT INFO

PIDFILE=/var/run/mock-core-configs/mock-core-configs.pid
CONF=/etc/mock-core-configs/mock-core-configs.ini
USER=mock-core-configs
GROUP=mock-core-configs
BIN=/usr/bin/mock-core-configs
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/mock-core-configs ]; then
    . /etc/default/mock-core-configs
fi

start_mock-core-configs(){
    log_daemon_msg "Starting mock-core-configs" "mock-core-configs" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "mock-core-configs already started"
        return 1
    fi
    mkdir -p `dirname $PIDFILE` -m 750
    chown $USER:$GROUP `dirname $PIDFILE`
    if start-stop-daemon -c $USER:$GROUP --start \
        --quiet --pidfile $PIDFILE \
        --oknodo --exec $BIN -- $OPTS
    then
        log_end_msg 0 || true
        return 0
    else
        log_end_msg 1 || true
        return 1
    fi

}

stop_mock-core-configs(){
    log_daemon_msg "Stopping mock-core-configs" "mock-core-configs" || true
    if start-stop-daemon --stop --quiet \
        --pidfile $PIDFILE
    then
        log_end_msg 0 || true
        return 0
    else
        log_end_msg 1 || true
        return 1
    fi
}

wait_stop(){
    c=0
    while pidofproc -p $PIDFILE $BIN >/dev/null && [ $c -lt 10 ]
    do
        sleep 0.5
        c=$(( $c + 1 ))
    done
}

case "$1" in
  start)
    start_mock-core-configs
    exit $?
    ;;
  stop)
    stop_mock-core-configs
    exit $?
    ;;
  restart)
    stop_mock-core-configs
    wait_stop
    start_mock-core-configs
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "mock-core-configs" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/mock-core-configs {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
