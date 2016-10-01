#!/bin/bash
export PYTHON_VERSION=3
export PYTHONPATH=/usr/src/libzbxpython/lib

cd /usr/src/libzbxpython

make_install() {
  make install || exit 1
  ln -s /usr/src/libzbxpython/lib /usr/lib/zabbix/modules/python3
}

case $1 in
  "reconf")
    ./autogen.sh \
      && ./configure \
        --libdir=/usr/lib/zabbix/modules \
        --with-zabbix=/usr/src/zabbix-3.2.0 \
        --with-zabbix-conf=/etc/zabbix \
      || exit 1
    ;;

  "agent")
    make_install
    /usr/sbin/zabbix_agentd \
      --config=/etc/zabbix/zabbix_agentd.conf \
      --foreground \
      || exit 1
    ;;

  "test")
    make_install
    zabbix_agentd -p | grep ^python
    ;;
    
  "bench")
    zabbix_agent_bench -threads 4 -keys /usr/src/zabbix_agent_bench.keys 
    ;;
    
  *)
    exec $@
    ;;
esac
