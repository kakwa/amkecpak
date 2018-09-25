#! /bin/sh

### BEGIN INIT INFO
# Provides:        python-swagger-spec-validator
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    python-swagger-spec-validator
### END INIT INFO

PIDFILE=/var/run/python-swagger-spec-validator/python-swagger-spec-validator.pid
CONF=/etc/python-swagger-spec-validator/python-swagger-spec-validator.ini
USER=python-swagger-spec-validator
GROUP=python-swagger-spec-validator
BIN=/usr/bin/python-swagger-spec-validator
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/python-swagger-spec-validator ]; then
    . /etc/default/python-swagger-spec-validator
fi

start_python-swagger-spec-validator(){
    log_daemon_msg "Starting python-swagger-spec-validator" "python-swagger-spec-validator" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "python-swagger-spec-validator already started"
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

stop_python-swagger-spec-validator(){
    log_daemon_msg "Stopping python-swagger-spec-validator" "python-swagger-spec-validator" || true
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
    start_python-swagger-spec-validator
    exit $?
    ;;
  stop)
    stop_python-swagger-spec-validator
    exit $?
    ;;
  restart)
    stop_python-swagger-spec-validator
    wait_stop
    start_python-swagger-spec-validator
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "python-swagger-spec-validator" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/python-swagger-spec-validator {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
