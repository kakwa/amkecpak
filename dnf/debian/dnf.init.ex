#! /bin/sh

### BEGIN INIT INFO
# Provides:        dnf
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    dnf
### END INIT INFO

PIDFILE=/var/run/dnf/dnf.pid
CONF=/etc/dnf/dnf.ini
USER=dnf
GROUP=dnf
BIN=/usr/bin/dnf
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/dnf ]; then
    . /etc/default/dnf
fi

start_dnf(){
    log_daemon_msg "Starting dnf" "dnf" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "dnf already started"
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

stop_dnf(){
    log_daemon_msg "Stopping dnf" "dnf" || true
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
    start_dnf
    exit $?
    ;;
  stop)
    stop_dnf
    exit $?
    ;;
  restart)
    stop_dnf
    wait_stop
    start_dnf
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "dnf" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/dnf {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
