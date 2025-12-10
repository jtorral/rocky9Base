#!/bin/bash

# Setup ssh for root using same keys as postgres

echo
echo "========================================================================"
echo "This is NOT secure. But this is for our own Docker environment so I "
echo "guess it's ok. We are setting up ssh for roo as well usingthe same keys"
echo "we use for user postgres. Just being lazy. Change afterwards if you want"
echo "========================================================================"
echo 

if [ ! -f "/root/.ssh/id_rsa" ]
then
   echo
   echo "Copying postgres ssh keys to user root so root can ssh accross nodes as well"
   echo "Using sam keys since this is local deploy and somewhat safe"
   echo
   mkdir -p /root/.ssh
   cp /id_rsa /root/.ssh
   cp /id_rsa.pub /root/.ssh
   cp /authorized_keys /root/.ssh
   chown -R root:root /root/.ssh
   chmod 0700 /root/.ssh
   chmod 0600 /root/.ssh/*
fi



# Setup some preconfigured ssh for trusting user postgres between containers

echo
echo "======================================================================"
echo "Doing some ssh voodoo so you don't have to. Even if you dont preconfig"
echo "======================================================================"
echo 

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]
then
   echo 
   echo "Running sopme ssh-keygen commands. Look at file entrypoint.sh for more details."
   echo 
   ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
   ssh-keygen -t dsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
   ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
fi


echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

/usr/sbin/sshd

rm -f /run/nologin

# consider using dumb_init in the future as a supervisor https://github.com/Yelp/dumb-init
# But for now just running a bash session detached to keep thinsg up
 
/bin/bash
