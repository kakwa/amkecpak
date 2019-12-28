#! /bin/sh

### BEGIN INIT INFO
# Provides:        scikit-build
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    scikit-build
### END INIT INFO

PIDFILE=/var/run/scikit-build/scikit-build.pid
CONF=/etc/scikit-build/scikit-build.ini
USER=scikit-build
GROUP=scikit-build
BIN=/usr/bin/scikit-build
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/scikit-build ]; then
    . /etc/default/scikit-build
fi

start_scikit-build(){
    log_daemon_msg "Starting scikit-build" "scikit-build" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "scikit-build already started"
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

stop_scikit-build(){
    log_daemon_msg "Stopping scikit-build" "scikit-build" || true
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
    start_scikit-build
    exit $?
    ;;
  stop)
    stop_scikit-build
    exit $?
    ;;
  restart)
    stop_scikit-build
    wait_stop
    start_scikit-build
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "scikit-build" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/scikit-build {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
