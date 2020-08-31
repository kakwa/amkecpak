#! /bin/sh

### BEGIN INIT INFO
# Provides:        snes9x
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    snes9x
### END INIT INFO

PIDFILE=/var/run/snes9x/snes9x.pid
CONF=/etc/snes9x/snes9x.ini
USER=snes9x
GROUP=snes9x
BIN=/usr/bin/snes9x
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/snes9x ]; then
    . /etc/default/snes9x
fi

start_snes9x(){
    log_daemon_msg "Starting snes9x" "snes9x" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "snes9x already started"
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

stop_snes9x(){
    log_daemon_msg "Stopping snes9x" "snes9x" || true
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
    start_snes9x
    exit $?
    ;;
  stop)
    stop_snes9x
    exit $?
    ;;
  restart)
    stop_snes9x
    wait_stop
    start_snes9x
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "snes9x" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/snes9x {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
