#!/bin/bash
export PYTHON_VERSION=3
export PYTHONPATH=/usr/src/libzbxpython/lib

cd /usr/src/libzbxpython

make_install() {
  make install || exit 1

  # TODO: install python module in instal target
  ln -s /usr/src/libzbxpython/lib /usr/lib/zabbix/modules/python3
}

case $1 in
  "reconf")
    [[ -f Makefile ]] && make distclean
    ./autogen.sh \
      && ./configure \
        --libdir=/usr/lib/zabbix/modules \
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
    debuild -us -uc

    # copy of container
    cp -v /tmp/zabbix-module-python_1.0.0-1_amd64.deb /usr/src/
    ;;
    
  *)
    exec $@
    ;;
esac
