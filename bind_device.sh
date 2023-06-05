#!/bin/bash

VENDOR="10ee 0100"
PCI=(
    0000:27:00.0
    0000:27:00.1
)

if [[ -z $1 ]]; then
    DRIVER=vfio-pci
else
    DRIVER=$1
fi

if [[ ! -d "/sys/bus/pci/drivers/vfio-pci" ]]; then
    sudo modprobe vfio-pci
fi

for dev in "${PCI[@]}"; do
    if [[ -d "/sys/bus/pci/devices/$dev/driver" ]]; then
        echo "$VENDOR" | sudo tee /sys/bus/pci/devices/"$dev"/driver/remove_id
        echo "$dev" | sudo tee /sys/bus/pci/devices/"$dev"/driver/unbind
    fi
    sleep 1
    echo "$VENDOR" | sudo tee /sys/bus/pci/drivers/"$DRIVER"/new_id
    echo "$dev" | sudo tee /sys/bus/pci/drivers/"$DRIVER"/bind
done

[[ $DRIVER = "vfio-pci" ]] && sudo chmod a+rw /dev/vfio/*
