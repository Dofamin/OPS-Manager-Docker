# OS
FROM ubuntu:latest
# Set version label
LABEL maintainer="github.com/Dofamin"
LABEL image="OPS Manager"
LABEL OS="Ubuntu/latest"
# ARG & ENV
ENV TZ=Europe/Moscow
ENV OPS_MGR_VERSION=6.0.7.100.20221129T1435Z
COPY container-image-root/ /
# Update system packages:
RUN apt -y update > /dev/null 2>&1;\
# Fix for select tzdata region
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone > /dev/null 2>&1;\
    dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1;\
# Install dependencies, you would need common set of tools.
    apt -y install curl wget ntp net-tools > /dev/null 2>&1;\
# Download release
    wget https://downloads.mongodb.com/on-prem-mms/tar/mongodb-mms-${OPS_MGR_VERSION}.tar.gz > /dev/null 2>&1;\
    tar -zxf mongodb-mms-${OPS_MGR_VERSION}.tar.gz > /dev/null 2>&1;\
# Cleanup
    rm -f *.tar.gz > /dev/null 2>&1;\
    apt -y clean > /dev/null 2>&1;\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* > /dev/null 2>&1;
# HEALTHCHECK
HEALTHCHECK --interval=60s --timeout=30s --start-period=5s CMD curl -f http://localhost:8080 || exit 1
# Expose Ports:
EXPOSE 8080
WORKDIR /mongodb-mms
# ENTRYPOINT
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]