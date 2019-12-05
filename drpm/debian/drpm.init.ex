#! /bin/sh

### BEGIN INIT INFO
# Provides:        drpm
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    drpm
### END INIT INFO

PIDFILE=/var/run/drpm/drpm.pid
CONF=/etc/drpm/drpm.ini
USER=drpm
GROUP=drpm
BIN=/usr/bin/drpm
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/drpm ]; then
    . /etc/default/drpm
fi

start_drpm(){
    log_daemon_msg "Starting drpm" "drpm" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "drpm already started"
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

stop_drpm(){
    log_daemon_msg "Stopping drpm" "drpm" || true
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
    start_drpm
    exit $?
    ;;
  stop)
    stop_drpm
    exit $?
    ;;
  restart)
    stop_drpm
    wait_stop
    start_drpm
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "drpm" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/drpm {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
