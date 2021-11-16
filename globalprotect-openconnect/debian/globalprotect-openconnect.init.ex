#! /bin/sh

### BEGIN INIT INFO
# Provides:        globalprotect-openconnect
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    globalprotect-openconnect
### END INIT INFO

PIDFILE=/var/run/globalprotect-openconnect/globalprotect-openconnect.pid
CONF=/etc/globalprotect-openconnect/globalprotect-openconnect.ini
USER=globalprotect-openconnect
GROUP=globalprotect-openconnect
BIN=/usr/bin/globalprotect-openconnect
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/globalprotect-openconnect ]; then
    . /etc/default/globalprotect-openconnect
fi

start_globalprotect-openconnect(){
    log_daemon_msg "Starting globalprotect-openconnect" "globalprotect-openconnect" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "globalprotect-openconnect already started"
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

stop_globalprotect-openconnect(){
    log_daemon_msg "Stopping globalprotect-openconnect" "globalprotect-openconnect" || true
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
    start_globalprotect-openconnect
    exit $?
    ;;
  stop)
    stop_globalprotect-openconnect
    exit $?
    ;;
  restart)
    stop_globalprotect-openconnect
    wait_stop
    start_globalprotect-openconnect
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "globalprotect-openconnect" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/globalprotect-openconnect {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
