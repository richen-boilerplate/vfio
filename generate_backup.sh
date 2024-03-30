#!/bin/bash

sudo cp -r /etc/libvirt/hooks ./hooks.bak
sudo cp /etc/libvirt/qemu/win11.xml ./win11.xml.bak
sudo chown -R "$USER": ./
