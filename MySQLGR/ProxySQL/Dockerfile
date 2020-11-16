FROM centos:7

### Install
### - Proxysql
### - mysql client which is needed for admin interface
### - Unzip which is needed for decompression of downloaded packages
RUN yum install -q -y \
  https://github.com/sysown/proxysql/releases/download/v2.0.6/proxysql-2.0.6-1-centos67.x86_64.rpm \
  mysql \
  unzip \
  wget

  
### Move startup and shutdown scripts to container
COPY scripts/* /opt/

CMD chmod +x /opt/*.sh; /opt/setupgr.sh; cp /opt/proxysql.cnf /etc/proxysql.cnf; /etc/rc.d/init.d/proxysql start; sleep infinity
