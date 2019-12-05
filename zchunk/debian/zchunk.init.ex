#! /bin/sh

### BEGIN INIT INFO
# Provides:        zchunk
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    zchunk
### END INIT INFO

PIDFILE=/var/run/zchunk/zchunk.pid
CONF=/etc/zchunk/zchunk.ini
USER=zchunk
GROUP=zchunk
BIN=/usr/bin/zchunk
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/zchunk ]; then
    . /etc/default/zchunk
fi

start_zchunk(){
    log_daemon_msg "Starting zchunk" "zchunk" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "zchunk already started"
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

stop_zchunk(){
    log_daemon_msg "Stopping zchunk" "zchunk" || true
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
    start_zchunk
    exit $?
    ;;
  stop)
    stop_zchunk
    exit $?
    ;;
  restart)
    stop_zchunk
    wait_stop
    start_zchunk
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "zchunk" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/zchunk {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
