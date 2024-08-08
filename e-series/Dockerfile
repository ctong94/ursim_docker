FROM ubuntu:20.04

LABEL description="UR simulator e-series"

ENV TZ "Asia/Shanghai"

ENV HOME /ursim

# Set robot model - Can be UR3, UR5, UR10 or UR16
ENV ROBOT_MODEL UR5

# Set display
ENV DISPLAY :1

# Change software source
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list &&\
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# Install dependencies
RUN apt-get update && \
    apt-get install -qy --no-install-recommends openjdk-8-jre psmisc && \
    apt-get -y install curl && \
    apt-get install -y x11vnc xvfb && \
    apt-get install -y vim && \
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java 10000

# Setup JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Extract URSim
COPY URSim_Linux-5.12.6.1102099.tar.gz /ursim.tar.gz
RUN tar xvf ursim.tar.gz && \
    rm ursim.tar.gz && \
    mv  /ursim* /ursim

# Install URSim
RUN cd /ursim && \
    sed -i 's|apt-get -y install|apt-get -qy install --no-install-recommends|g' install.sh && \
    sed -i 's|tty -s|(exit 0)|g' install.sh && \
    sed -i 's|needToInstallJava$|(exit 0)|g' install.sh && \
    sed -i '/for TYPE in UR3 UR5 UR10 UR16/,$ d' install.sh  && \
    sed -i 's/libcurl3/libcurl4/g' install.sh  && \
    sed -i 's|pkexec ||g' install.sh && \
    sed -i 's|sudo ||g' install.sh && \
    sed -i 's|sudo ||g' ursim-certificate-check.sh && \
    ./install.sh

# Clean up
RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Make it possible for polyscope to find uradmin scripts
ENV PATH "$PATH:/ursim/usr/bin"

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Make a directory to store urcaps
RUN mkdir /urcaps

# VNC viewer
EXPOSE 5900
# Modbus Port
EXPOSE 502
# Interface Ports
EXPOSE 29999
EXPOSE 30001-30004

# This will start the simulator
ENTRYPOINT ["/entrypoint.sh"]
