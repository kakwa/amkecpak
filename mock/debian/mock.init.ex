#! /bin/sh

### BEGIN INIT INFO
# Provides:        mock
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    mock
### END INIT INFO

PIDFILE=/var/run/mock/mock.pid
CONF=/etc/mock/mock.ini
USER=mock
GROUP=mock
BIN=/usr/bin/mock
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/mock ]; then
    . /etc/default/mock
fi

start_mock(){
    log_daemon_msg "Starting mock" "mock" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "mock already started"
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

stop_mock(){
    log_daemon_msg "Stopping mock" "mock" || true
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
    start_mock
    exit $?
    ;;
  stop)
    stop_mock
    exit $?
    ;;
  restart)
    stop_mock
    wait_stop
    start_mock
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "mock" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/mock {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
