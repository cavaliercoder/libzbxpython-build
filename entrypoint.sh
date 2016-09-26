#!/bin/bash
export PYTHONPATH=/usr/src/libzbxpython/lib

# link module path
rm -r /var/lib/zabbix/modules/python
ln -s /usr/src/libzbxpython/lib /var/lib/zabbix/modules/python

case $1 in
  "release")
    export PYTHON_VERSION=3.4
    cd /usr/src/libzbxpython
    ./autogen.sh \
      && ./configure \
        --enable-debug \
        --with-zabbix=/usr/src/zabbix-3.2.0 \
      && make dist \
      && make \
      || exit 1
    ;;

  "make")
    cd /usr/src/libzbxpython
    make || exit 1
    ;;

  "agent")
    /usr/sbin/zabbix_agentd \
      --config=/etc/zabbix/zabbix_agentd.conf \
      --foreground \
      || exit 1
    ;;

  "test")
    zabbix_agentd -p | grep ^python
    ;;
    
  *)
    exec $@
    ;;
esac
