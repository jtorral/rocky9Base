FROM rockylinux:9.3 AS base

# Install necessary packages and clean up in one layer
RUN dnf -y update && \
    dnf install -y wget telnet jq vim sudo gnupg openssh-server openssh-clients \
                   procps-ng net-tools iproute iputils less diffutils watchdog epel-release && \
    dnf clean all && rm -rf /var/cache/dnf

# Install libmemcached-awesome directly from the repository
RUN dnf install -y https://dl.rockylinux.org/pub/rocky/9/CRB/x86_64/os/Packages/l/libmemcached-awesome-1.1.0-12.el9.x86_64.rpm && \
    dnf --enablerepo=crb install -y libmemcached-awesome && \
    dnf clean all

# Copy configuration files and scripts

COPY id_rsa / 
COPY id_rsa.pub / 
COPY authorized_keys / 

# Expose ports
EXPOSE 22 80 443 5432 2379 2380 6032 6033 6132 6133 8432 5000 5001 8008 9999 9898 7000 

# Entrypoint
COPY entrypoint.sh / 
RUN chmod +x /entrypoint.sh 
ENTRYPOINT ["/entrypoint.sh"]
