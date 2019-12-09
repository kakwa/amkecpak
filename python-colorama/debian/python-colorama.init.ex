#! /bin/sh

### BEGIN INIT INFO
# Provides:        python-colorama
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    python-colorama
### END INIT INFO

PIDFILE=/var/run/python-colorama/python-colorama.pid
CONF=/etc/python-colorama/python-colorama.ini
USER=python-colorama
GROUP=python-colorama
BIN=/usr/bin/python-colorama
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/python-colorama ]; then
    . /etc/default/python-colorama
fi

start_python-colorama(){
    log_daemon_msg "Starting python-colorama" "python-colorama" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "python-colorama already started"
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

stop_python-colorama(){
    log_daemon_msg "Stopping python-colorama" "python-colorama" || true
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
    start_python-colorama
    exit $?
    ;;
  stop)
    stop_python-colorama
    exit $?
    ;;
  restart)
    stop_python-colorama
    wait_stop
    start_python-colorama
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "python-colorama" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/python-colorama {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
