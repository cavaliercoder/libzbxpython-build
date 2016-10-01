FROM debian:jessie

# configure apt
ENV DEBIAN_FRONTEND noninteractive

COPY sources.list /etc/apt/sources.list

# install build tools
RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  devscripts \
  dh-make \
  gcc \
  gdb \
  libtool \
  lsof \
  m4 \
  make \
  python \
  python-dev \
  python-setuptools \
  python3 \
  python3-dev \
  python3-setuptools

# install zabbix agent
RUN \
  curl -LO http://repo.zabbix.com/zabbix/3.2/debian/pool/main/z/zabbix-release/zabbix-release_3.2-1+jessie_all.deb \
  && dpkg -i zabbix-release_3.2-1+jessie_all.deb \
  && apt-get update \
  && apt-get install -y zabbix-agent zabbix-get zabbix-sender \
  && rm -rf /var/lib/apt/lists/*

# install zabbix_agent_bench
RUN curl -LO https://sourceforge.net/projects/zabbixagentbench/files/linux/zabbix_agent_bench-0.4.0.x86_64.tar.gz \
  && tar -xzvf zabbix_agent_bench-0.4.0.x86_64.tar.gz \
  && cp -vf zabbix_agent_bench-0.4.0.x86_64/zabbix_agent_bench /usr/bin/zabbix_agent_bench \
  && rm -rvf zabbix_agent_bench-0.4.0.x86_64*

# configure agent module
RUN \
  echo "AllowRoot=1" >> /etc/zabbix/zabbix_agentd.conf \
  && echo "LogType=console" >> /etc/zabbix/zabbix_agentd.conf \
  && mkdir -p /var/run/zabbix

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
