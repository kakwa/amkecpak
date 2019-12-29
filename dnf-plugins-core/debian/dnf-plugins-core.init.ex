#! /bin/sh

### BEGIN INIT INFO
# Provides:        dnf-plugins-core
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    dnf-plugins-core
### END INIT INFO

PIDFILE=/var/run/dnf-plugins-core/dnf-plugins-core.pid
CONF=/etc/dnf-plugins-core/dnf-plugins-core.ini
USER=dnf-plugins-core
GROUP=dnf-plugins-core
BIN=/usr/bin/dnf-plugins-core
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/dnf-plugins-core ]; then
    . /etc/default/dnf-plugins-core
fi

start_dnf-plugins-core(){
    log_daemon_msg "Starting dnf-plugins-core" "dnf-plugins-core" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "dnf-plugins-core already started"
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

stop_dnf-plugins-core(){
    log_daemon_msg "Stopping dnf-plugins-core" "dnf-plugins-core" || true
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
    start_dnf-plugins-core
    exit $?
    ;;
  stop)
    stop_dnf-plugins-core
    exit $?
    ;;
  restart)
    stop_dnf-plugins-core
    wait_stop
    start_dnf-plugins-core
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "dnf-plugins-core" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/dnf-plugins-core {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
