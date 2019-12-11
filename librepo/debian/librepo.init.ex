#! /bin/sh

### BEGIN INIT INFO
# Provides:        librepo
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    librepo
### END INIT INFO

PIDFILE=/var/run/librepo/librepo.pid
CONF=/etc/librepo/librepo.ini
USER=librepo
GROUP=librepo
BIN=/usr/bin/librepo
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/librepo ]; then
    . /etc/default/librepo
fi

start_librepo(){
    log_daemon_msg "Starting librepo" "librepo" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "librepo already started"
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

stop_librepo(){
    log_daemon_msg "Stopping librepo" "librepo" || true
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
    start_librepo
    exit $?
    ;;
  stop)
    stop_librepo
    exit $?
    ;;
  restart)
    stop_librepo
    wait_stop
    start_librepo
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "librepo" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/librepo {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
