#! /bin/sh

### BEGIN INIT INFO
# Provides:        python-connexion
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    python-connexion
### END INIT INFO

PIDFILE=/var/run/python-connexion/python-connexion.pid
CONF=/etc/python-connexion/python-connexion.ini
USER=python-connexion
GROUP=python-connexion
BIN=/usr/bin/python-connexion
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/python-connexion ]; then
    . /etc/default/python-connexion
fi

start_python-connexion(){
    log_daemon_msg "Starting python-connexion" "python-connexion" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "python-connexion already started"
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

stop_python-connexion(){
    log_daemon_msg "Stopping python-connexion" "python-connexion" || true
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
    start_python-connexion
    exit $?
    ;;
  stop)
    stop_python-connexion
    exit $?
    ;;
  restart)
    stop_python-connexion
    wait_stop
    start_python-connexion
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "python-connexion" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/python-connexion {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
