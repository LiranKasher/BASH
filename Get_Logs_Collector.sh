#!/bin/sh

mkdir -p /usr/local/disk2/unix_nt/error_log_collector/`date -d "1 day ago" '+%Y-%m-%d'`/`hostname`/error_logs/history
mkdir -p /usr/local/disk2/unix_nt/error_log_collector/`date -d "1 day ago" '+%Y-%m-%d'`/`hostname`/logs

find /usr/local/insight/error_log -name "*system.errorLog*" -mtime -1 | xargs -i cp -nrp \{\} /usr/local/disk2/unix_nt/error_log_collector/`date -d "1 day ago" '+%Y-%m-%d'`/`hostname`/error_logs
find /usr/local/insight/Logs -name "*log*" -mtime -1 | xargs -i cp -nrp \{\} /usr/local/disk2/unix_nt/error_log_collector/`date -d "1 day ago" '+%Y-%m-%d'`/`hostname`/logs

find /usr/local/insight/error_log/.history -name "stackTrace.crashesLog*" -mtime -1 | xargs -i cp -nrp \{\} /usr/local/disk2/unix_nt/error_log_collector/`date -d "1 day ago" '+%Y-%m-%d'`/`hostname`/error_logs/history
find /usr/local/insight/error_log/.history -name "*.gz" -mtime -1 | xargs -i cp -nrp \{\} /usr/local/disk2/unix_nt/error_log_collector/`date -d "1 day ago" '+%Y-%m-%d'`/`hostname`/error_logs/history
find /usr/local/disk2/unix_nt/error_log_collector/`date -d "1 day ago" '+%Y-%m-%d'` -name '*.gz' -exec bash -c 'mv -v "$0" "`echo $0 | tr ":" "-"`"' {} \;

#find /usr/local/disk2/unix_nt/error_log_collector/history -maxdepth 1 -type f -mtime +6 | xargs -i rm -rf \{\}
find /usr/local/disk2/unix_nt/error_log_collector -maxdepth 1 -type d -mtime +6 | xargs -i rm -rf \{\}