FROM centos:6

RUN set -x && \
    yum update -y && \
    yum install -y git make gcc-c++ patch libyaml-devel libffi-devel libicu-devel zlib-devel readline-devel libxml2-devel libxslt-devel ImageMagick ImageMagick-devel openssl-devel && \
    curl -sL https://rpm.nodesource.com/setup_6.x | bash - && \
    yum install -y nodejs mysql-devel yum-utils && \
    git clone https://github.com/rbenv/rbenv.git /opt/rbenv && \
    echo 'export RBENV_ROOT=/opt/rbenv' >> /etc/profile  && \
    echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile  && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile && \
    source /etc/profile && \
    git clone https://github.com/sstephenson/ruby-build.git /opt/rbenv/plugins/ruby-build && \
    chmod -R 777 /opt/rbenv && \
    rbenv rehash && \
    rbenv install 2.5.1 && \
    rbenv global 2.5.1 && \
    rbenv rehash && \
    yum -y install http://dev.mysql.com/get/mysql80-community-release-el6-3.noarch.rpm && \
    yum-config-manager --disable mysql80-community && \
    yum-config-manager --enable mysql56-community && \
    yum install -y  mysql-community-server
    
