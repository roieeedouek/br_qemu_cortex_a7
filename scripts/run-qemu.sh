#!/bin/bash

qemu-system-arm \
    -M virt \
    -cpu cortex-a7 \
    -m 256 \
    -kernel zImage \
    -drive file=rootfs.ext2,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -nographic \
    -no-reboot \
    -append "rootwait root=/dev/vda console=ttyAMA0" \
    -device virtio-net-device,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::5555-:22