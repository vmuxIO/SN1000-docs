# SN1000 Documentation

## Setup
By default the SN1000 card do not have any OS installed, it can only boot in maintenance mode.

In order to do anything with the card other than simple ethernet, OS must be installed first.

### xnsocadmin
`xnsocadmin` is an execuable provided by Xilinx to manage the card. It's statically linked and can be used separately.

### Serial Connection
The maintenance OS somehow does not pick up usb connection before actual OS installation. Before that, only serial connection is possible.

#### USB-uart Adapter
To establish serial connection, you'll need a usb-uart adapter cable as shown in the diagram first.
Some uart adapter might have compatibility issue, the reason is unknown yet.
The USB-female header is used to connect usb pheripheral devices to the SN1000 card, such as USB-ethernet adapter or USB drives. Note that it can only work at about 100 mbps (still a lot faster than serial).

![uart](assets/uart-cable.svg)

#### picocom
After connecting the cable to the card, a tty device will appear as `/dev/ttyUSBx`. If there are more than one device available, you'll need to find out which device is correct by e.g. `lsusb`. Here we assume the correct device is `ttyUSB0`.

To make the actual connection, run:

```
# picocom /dev/ttyUSB0 -b 115200
```

For unknown reason in `minicom` only RX works, nothing can be sent. Use picocom instead.

Make sure the terminal is using the correct configuration:
- databits: 8
- stopbits: 1
- parity: none
- baudrate: 115200

After that, open another terminal on the host and boot the card into maintenance mode:
```
# xnsocadmin ioctl.char=/dev/ttyUSB0 maintenance
```

You will see outputs in picocom at the same time. After the device is correctly booted, login into the maintenance kernel with root(password: root)

### USB Ethernet Connection
