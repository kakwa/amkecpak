#! /bin/sh

### BEGIN INIT INFO
# Provides:        libcomps
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    libcomps
### END INIT INFO

PIDFILE=/var/run/libcomps/libcomps.pid
CONF=/etc/libcomps/libcomps.ini
USER=libcomps
GROUP=libcomps
BIN=/usr/bin/libcomps
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/libcomps ]; then
    . /etc/default/libcomps
fi

start_libcomps(){
    log_daemon_msg "Starting libcomps" "libcomps" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "libcomps already started"
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

stop_libcomps(){
    log_daemon_msg "Stopping libcomps" "libcomps" || true
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
    start_libcomps
    exit $?
    ;;
  stop)
    stop_libcomps
    exit $?
    ;;
  restart)
    stop_libcomps
    wait_stop
    start_libcomps
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "libcomps" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/libcomps {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
