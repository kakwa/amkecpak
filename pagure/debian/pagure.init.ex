#! /bin/sh

### BEGIN INIT INFO
# Provides:        pagure
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    pagure
### END INIT INFO

PIDFILE=/var/run/pagure/pagure.pid
CONF=/etc/pagure/pagure.ini
USER=pagure
GROUP=pagure
BIN=/usr/bin/pagure
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/pagure ]; then
    . /etc/default/pagure
fi

start_pagure(){
    log_daemon_msg "Starting pagure" "pagure" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "pagure already started"
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

stop_pagure(){
    log_daemon_msg "Stopping pagure" "pagure" || true
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
    start_pagure
    exit $?
    ;;
  stop)
    stop_pagure
    exit $?
    ;;
  restart)
    stop_pagure
    wait_stop
    start_pagure
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "pagure" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/pagure {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
