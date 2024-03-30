#!/usr/bin/env bash
# https://rokups.github.io/#!pages/gaming-vm-performance.md

date=$(date '+%Y-%m-%d %H:%M:%S')

TOTAL_CORES='0-19'
TOTAL_CORES_MASK=FFFFF # bitmask 0b11111111111111111111
HOST_CORES='16-19'     # Cores reserved for host
HOST_CORES_MASK=F000   # bitmask 0b11110000000000000000
VIRT_CORES='0-15'      # Cores reserved for virtual machine(s)
VIRT_CORES_MASK=0FFF   # bitmask 0b00001111111111111111

shield_vm() {
    cset set -c $TOTAL_CORES -s machine.slice
    # Shield two cores cores for host and rest for VM(s)
    cset shield --kthread on --cpu $VIRT_CORES
}

unshield_vm() {
    echo $TOTAL_CORES_MASK >/sys/bus/workqueue/devices/writeback/cpumask
    cset shield --reset
}

echo "$date - win11/release/end: allocating cpu to host" >>/home/richard/Development/vfio/main.log

systemctl set-property --runtime -- user.slice AllowedCPUs=$TOTAL_CORES
systemctl set-property --runtime -- system.slice AllowedCPUs=$TOTAL_CORES
systemctl set-property --runtime -- init.scope AllowedCPUs=$TOTAL_CORES

# All VMs offline
sysctl vm.stat_interval=1
sysctl -w kernel.watchdog=1
unshield_vm
# echo always >/sys/kernel/mm/transparent_hugepage/enabled
echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
echo 1 >/sys/bus/workqueue/devices/writeback/numa
echo >&2 "VMs UnShielded"
