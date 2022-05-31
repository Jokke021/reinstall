#!/bin/bash
rm /etc/apt/sources.list
rm /etc/apt/sources.list.d/pve-enterprise.list
echo '# Proxmox VE Enterprise Repository' >> /etc/apt/sources.list.d/pve-enterprise.list
echo '#### DISABLE ###deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise' >> /etc/apt/sources.list.d/pve-enterprise.list
echo '# Repository SE-Mirror' >> /etc/apt/sources.list
echo 'deb http://ftp.se.echo 'debian.org/echo 'debian bullseye main contrib non-free' >> /etc/apt/sources.list
echo 'deb-src http://ftp.se.echo 'debian.org/echo 'debian bullseye main contrib non-free' >> /etc/apt/sources.list
echo '# Security updates SE-Mirror' >> /etc/apt/sources.list
echo 'deb http://ftp.se.echo 'debian.org/echo 'debian-security/ bullseye-security main contrib non-free' >> /etc/apt/sources.list
echo 'deb-src http://ftp.se.echo 'debian.org/echo 'debian-security/ bullseye-security main contrib non-free' >> /etc/apt/sources.list
echo 'deb http://ftp.se.echo 'debian.org/echo 'debian bullseye-updates main contrib non-free' >> /etc/apt/sources.list
echo 'deb-src http://ftp.se.echo 'debian.org/echo 'debian bullseye-updates main contrib non-free' >> /etc/apt/sources.list
echo '# pve-no-subscription' >> /etc/apt/sources.list.d/pve-nosubscription.list
echo 'deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription' >> /etc/apt/sources.list.d/pve-nosubscription.list
echo '# Ceph' >> /etc/apt/sources.list.d/ceph.list
echo 'deb http://download.proxmox.com/debian/ceph-pacific bullseye main contrib non-free' >> /etc/apt/sources.list.d/ceph.list
echo 'deb http://download.proxmox.com/debian/ceph-octopus bullseye main contrib non-free' >> /etc/apt/sources.list.d/ceph.list
apt update -y
apt dist-upgrade -y
apt-get install --download-only pveceph -y
# Remove Sub Notice
echo '[Unit]' >> "/etc/systemd/system/no-subscription-notice.service"
echo 'Description=Remove Proxmox VE subscription notice' >> "/etc/systemd/system/no-subscription-notice.service"
echo 'Before=pveproxy.service' >> "/etc/systemd/system/no-subscription-notice.service"
echo '#' >> "/etc/systemd/system/no-subscription-notice.service"
echo '[Service]' >> "/etc/systemd/system/no-subscription-notice.service"
echo 'Type=oneshot' >> "/etc/systemd/system/no-subscription-notice.service"
echo 'ExecStart=/bin/sh -c "grep --files-with-matches --include '*.js' --recursive --null 'checked_command:\s*function(orig_cmd)' /usr/share/ | xargs --null --no-run-if-empty sed --in-place 's/checked_command:\s*function(orig_cmd)\s*{\s*$/& orig_cmd(); return;/'"' >> "/etc/systemd/system/no-subscription-notice.service"
echo '#' >> "/etc/systemd/system/no-subscription-notice.service"
echo '[Install]' >> "/etc/systemd/system/no-subscription-notice.service"
echo 'WantedBy=pveproxy.service' >> "/etc/systemd/system/no-subscription-notice.service"
# END Remove Sub Notice
systemctl enable --now no-subscription-notice.service
rm $0