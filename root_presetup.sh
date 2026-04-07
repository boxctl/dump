#!/usr/bin/env bash
{
    adduser boxadmin
    usermod -aG sudo boxadmin
    mkdir -p /home/boxadmin/.ssh
    cp /root/.ssh/authorized_keys /home/boxadmin/.ssh/authorized_keys
    chown -R boxadmin:boxadmin /home/boxadmin/.ssh
    chmod 700 /home/boxadmin/.ssh
    chmod 600 /home/boxadmin/.ssh/authorized_keys
}