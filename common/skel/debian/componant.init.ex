#! /bin/sh

### BEGIN INIT INFO
# Provides:        @@COMPONENT_NAME@@
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    @@COMPONENT_NAME@@
### END INIT INFO

PIDFILE=/var/run/@@COMPONENT_NAME@@/@@COMPONENT_NAME@@.pid
CONF=/etc/@@COMPONENT_NAME@@/@@COMPONENT_NAME@@.ini
USER=@@COMPONENT_NAME@@
GROUP=@@COMPONENT_NAME@@
BIN=/usr/bin/@@COMPONENT_NAME@@
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/@@COMPONENT_NAME@@ ]; then
    . /etc/default/@@COMPONENT_NAME@@
fi

start_@@COMPONENT_NAME@@(){
    log_daemon_msg "Starting @@COMPONENT_NAME@@" "@@COMPONENT_NAME@@" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "@@COMPONENT_NAME@@ already started"
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

stop_@@COMPONENT_NAME@@(){
    log_daemon_msg "Stopping @@COMPONENT_NAME@@" "@@COMPONENT_NAME@@" || true
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
    start_@@COMPONENT_NAME@@
    exit $?
    ;;
  stop)
    stop_@@COMPONENT_NAME@@
    exit $?
    ;;
  restart)
    stop_@@COMPONENT_NAME@@
    wait_stop
    start_@@COMPONENT_NAME@@
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "@@COMPONENT_NAME@@" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/@@COMPONENT_NAME@@ {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
