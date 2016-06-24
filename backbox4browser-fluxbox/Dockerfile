FROM ubuntu:14.04 

ENV backboxuser bbuser
# Let the conatiner know that there is no tty 
ENV DEBIAN_FRONTEND noninteractive

# Keep upstart from complaining 
RUN dpkg-divert --rename --add /usr/sbin/invoke-rc.d
RUN ln -s /bin/true /usr/sbin/invoke-rc.d

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start. 
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup && \
    echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean && \
    echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean && \
    echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean && \
    echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages && \
    echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes

RUN apt-get update

# Install ubuntu pkgs
RUN apt-get install -y ca-certificates inotify-tools pwgen fluxbox supervisor unzip wget python-setuptools \
net-tools git x11vnc xvfb software-properties-common

# Add multiserve repo
RUN add-apt-repository -y "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse"
RUN add-apt-repository -y "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse"

# Add BackBox 4.x Launchpad repo
RUN add-apt-repository -y ppa:backbox/four

# Add rubygems pkgs
RUN mkdir -p /usr/lib/ruby/2.1.0/rubygems/ssl_certs/ && \
    mkdir -p /usr/lib/ruby/2.2.0/rubygems/ssl_certs/ && \
    cd /usr/lib/ruby/2.1.0/rubygems/ssl_certs/ && \
    wget https://raw.githubusercontent.com/rubygems/rubygems/master/lib/rubygems/ssl_certs/rubygems.org/AddTrustExternalCARoot.pem && \
    cd /usr/lib/ruby/2.2.0/rubygems/ssl_certs/ && \
    wget https://raw.githubusercontent.com/rubygems/rubygems/master/lib/rubygems/ssl_certs/rubygems.org/AddTrustExternalCARoot.pem

# Add ruby pkgs
RUN apt-get update && apt-get install -y ruby ruby-dev ruby2.1 ruby2.1-dev ruby2.2 ruby2.2-dev rubygems
# Add backbox pkgs
#RUN apt-get -y install backbox-tools

RUN sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# Add user
RUN useradd -ms /bin/bash $backboxuser 
RUN usermod -a -G sudo $backboxuser
RUN echo "$backboxuser:$backboxuser"| chpasswd

# Add startup script
ADD startup.sh /home/$backboxuser/startup.sh
RUN chmod 755 /home/$backboxuser/startup.sh && chown $backboxuser.$backboxuser /home/bbuser/startup.sh

# Change user and workdir
USER $backboxuser
WORKDIR /home/$backboxuser

RUN cd /home/$backboxuser && git clone https://github.com/kanaka/noVNC.git && \
cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify

CMD /home/$backboxuser/startup.sh
