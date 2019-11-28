#! /bin/sh

### BEGIN INIT INFO
# Provides:        distribution-gpg-keys
# Required-Start:    $remote_fs $network $syslog
# Required-Stop:    $remote_fs $network $syslog
# Default-Start:    2 3 4 5
# Default-Stop:        
# Short-Description:    distribution-gpg-keys
### END INIT INFO

PIDFILE=/var/run/distribution-gpg-keys/distribution-gpg-keys.pid
CONF=/etc/distribution-gpg-keys/distribution-gpg-keys.ini
USER=distribution-gpg-keys
GROUP=distribution-gpg-keys
BIN=/usr/bin/distribution-gpg-keys
OPTS="-d -c $CONF -p $PIDFILE"

. /lib/lsb/init-functions

if [ -f /etc/default/distribution-gpg-keys ]; then
    . /etc/default/distribution-gpg-keys
fi

start_distribution-gpg-keys(){
    log_daemon_msg "Starting distribution-gpg-keys" "distribution-gpg-keys" || true
    pidofproc -p $PIDFILE $BIN >/dev/null
    status="$?"
    if [ $status -eq 0 ]
    then
        log_end_msg 1 
        log_failure_msg \
        "distribution-gpg-keys already started"
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

stop_distribution-gpg-keys(){
    log_daemon_msg "Stopping distribution-gpg-keys" "distribution-gpg-keys" || true
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
    start_distribution-gpg-keys
    exit $?
    ;;
  stop)
    stop_distribution-gpg-keys
    exit $?
    ;;
  restart)
    stop_distribution-gpg-keys
    wait_stop
    start_distribution-gpg-keys
    exit $?
    ;;
  status)
    status_of_proc -p $PIDFILE $BIN "distribution-gpg-keys" \
        && exit 0 || exit $?
    ;;
  *)
    log_action_msg \
    "Usage: /etc/init.d/distribution-gpg-keys {start|stop|restart|status}" \
    || true
    exit 1
esac

exit 0
