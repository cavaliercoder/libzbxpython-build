#!/bin/bash
export PYTHON_VERSION=3
export ZABBIX_HEADERS=/usr/src/zabbix-3.2.0

cd /usr/src/libzbxpython

case $1 in
  "reconf")
    [[ -f Makefile ]] && make distclean
    ./autogen.sh \
      && ./configure \
        --libdir=/usr/lib/zabbix/modules \
        --with-zabbix=/usr/src/zabbix-3.2.0 \
        --with-zabbix-conf=/etc/zabbix \
      || exit 1
    ;;

  "agent")
    make install
    /usr/sbin/zabbix_agentd \
      --config=/etc/zabbix/zabbix_agentd.conf \
      --foreground \
      || exit 1
    ;;

  "test")
    make install
    zabbix_agentd -p | grep ^python
    ;;
    
  "bench")
    zabbix_agent_bench -threads 4 -keys /usr/src/zabbix_agent_bench.keys 
    ;;

  "deb")
    make dist

    # extract sources
    tar -xzvC /tmp -f libzbxpython-1.0.0.tar.gz 
    mv -v /tmp/libzbxpython-1.0.0 /tmp/zabbix-module-python-1.0.0/

    # copy tarball
    cp -v libzbxpython-1.0.0.tar.gz /tmp/zabbix-module-python_1.0.0.orig.tar.gz

    # copy debian control
    cp -rv /usr/src/debian/ /tmp/zabbix-module-python-1.0.0/debian

    # build
    cd /tmp/zabbix-module-python-1.0.0/
    debuild \
      -e ZABBIX_HEADERS \
      -e PYTHON_VERSION \
      -us -uc || exit 1

    # copy of container
    cp -v /tmp/*.deb /usr/src/libzbxpython/

    # install and test
    dpkg-deb -I ../zabbix-module-python_1.0.0-1_amd64.deb
    dpkg-deb -c ../zabbix-module-python_1.0.0-1_amd64.deb
    dpkg -i ../zabbix-module-python_1.0.0-1_amd64.deb
    zabbix_agentd -p | grep ^python
    ;;
    
  *)
    exec $@
    ;;
esac
