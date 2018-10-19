#! /bin/sh

### BEGIN INIT INFO
# Provides:        python-inflection
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    python-inflection
### END INIT INFO

PIDFILE=/var/run/python-inflection/python-inflection.pid
CONF=/etc/python-inflection/python-inflection.ini
USER=python-inflection
GROUP=python-inflection
BIN=/usr/bin/python-inflection
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/python-inflection ]; then
    . /etc/default/python-inflection
fi

start_python-inflection(){
    log_daemon_msg "Starting python-inflection" "python-inflection" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "python-inflection already started"
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

stop_python-inflection(){
    log_daemon_msg "Stopping python-inflection" "python-inflection" || true
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
    start_python-inflection
    exit $?
    ;;
  stop)
    stop_python-inflection
    exit $?
    ;;
  restart)
    stop_python-inflection
    wait_stop
    start_python-inflection
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "python-inflection" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/python-inflection {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
