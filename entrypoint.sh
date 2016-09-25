#!/bin/bash
export PYTHONPATH=/usr/src/libzbxpython/lib

case $1 in
  "release")
    cd /usr/src/libzbxpython
    ./autogen.sh
    ./configure --with-zabbix=/usr/src/zabbix-3.2.0
    make dist
    make
    ;;

  "make")
    cd /usr/src/libzbxpython
    make
    ;;

  "agent")
    /usr/sbin/zabbix_agentd \
      --config=/etc/zabbix/zabbix_agentd.conf \
      --foreground
    ;;

  *)
    exec $@
    ;;
esac
