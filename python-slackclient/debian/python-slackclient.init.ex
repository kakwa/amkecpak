#! /bin/sh

### BEGIN INIT INFO
# Provides:        python-slackclient
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    python-slackclient
### END INIT INFO

PIDFILE=/var/run/python-slackclient/python-slackclient.pid
CONF=/etc/python-slackclient/python-slackclient.ini
USER=python-slackclient
GROUP=python-slackclient
BIN=/usr/bin/python-slackclient
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/python-slackclient ]; then
    . /etc/default/python-slackclient
fi

start_python-slackclient(){
    log_daemon_msg "Starting python-slackclient" "python-slackclient" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "python-slackclient already started"
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

stop_python-slackclient(){
    log_daemon_msg "Stopping python-slackclient" "python-slackclient" || true
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
    start_python-slackclient
    exit $?
    ;;
  stop)
    stop_python-slackclient
    exit $?
    ;;
  restart)
    stop_python-slackclient
    wait_stop
    start_python-slackclient
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "python-slackclient" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/python-slackclient {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
