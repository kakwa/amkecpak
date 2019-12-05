#! /bin/sh

### BEGIN INIT INFO
# Provides:        createrepo_c
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    createrepo_c
### END INIT INFO

PIDFILE=/var/run/createrepo_c/createrepo_c.pid
CONF=/etc/createrepo_c/createrepo_c.ini
USER=createrepo_c
GROUP=createrepo_c
BIN=/usr/bin/createrepo_c
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/createrepo_c ]; then
    . /etc/default/createrepo_c
fi

start_createrepo_c(){
    log_daemon_msg "Starting createrepo_c" "createrepo_c" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "createrepo_c already started"
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

stop_createrepo_c(){
    log_daemon_msg "Stopping createrepo_c" "createrepo_c" || true
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
    start_createrepo_c
    exit $?
    ;;
  stop)
    stop_createrepo_c
    exit $?
    ;;
  restart)
    stop_createrepo_c
    wait_stop
    start_createrepo_c
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "createrepo_c" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/createrepo_c {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
