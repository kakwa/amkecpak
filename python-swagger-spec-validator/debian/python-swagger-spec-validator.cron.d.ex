#
# Regular cron jobs for the dash package
#
0 4	* * *	root	[ -x /usr/bin/dash_maintenance ] && /usr/bin/dash_maintenance
