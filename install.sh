#!/bin/bash

# move the hooks dir to /etc/libvirt/hooks
sudo rm -rf /etc/libvirt/hooks
sudo cp -r ./hooks /etc/libvirt/

# chown the hooks dir to the current user
sudo chown -R "$USER": /etc/libvirt/hooks/
sudo chown -R :kvm /etc/libvirt/hooks/
sudo chown -R :libvirt /etc/libvirt/hooks/
sudo chown -R :qemu /etc/libvirt/hooks/
sudo chmod -R 777 /etc/libvirt/hooks/
sudo chown -R "$USER": ./
sudo chmod -R 777 ./

sudo systemctl restart libvirtd
