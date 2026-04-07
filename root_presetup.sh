#!/usr/bin/env bash

set -euo pipefail

useradd -m -s /bin/bash -G sudo boxadmin
mkdir -p /home/boxadmin/.ssh
cp /root/.ssh/authorized_keys /home/boxadmin/.ssh/authorized_keys
chown -R boxadmin:boxadmin /home/boxadmin/.ssh
chmod 700 /home/boxadmin/.ssh
chmod 600 /home/boxadmin/.ssh/authorized_keys
