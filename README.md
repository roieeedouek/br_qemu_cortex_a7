# Buildroot QEMU Cortex A7 configuration

This is a buildroot configuration for emulating a system with ARM Cortex A7 core on the [virt platform](https://www.qemu.org/docs/master/system/arm/virt.html). The setup is designed as a test runner or debug system and goes beyond the minimal buildroot configuration. This includes

* ssh access as `root`
* ...

## Usage
Clone the buildroot repository
```
git clone https://git.busybox.net/buildroot
```
and this repository so they sit on the same level.
```
git clone https://github.com/dlips/br_qemu_cortex_a7.git
```
Then switch to the buildroot directory with `cd buildroot` and create a new defconfig using `br_qemu_cortex_a7` as `BR2_EXTERNAL` ([see documentation](https://buildroot.org/downloads/manual/manual.html#outside-br-custom))
```
make BR2_EXTERNAL=../br_qemu_cortex_a7 O=../my_br_build qemu_cortex_a7_defconfig
```
Afterwards you can customize the image with 
```
make O=../my_br_build menuconfig
```
and then build the system running
```
make O=../my_br_build
```

## Commands

### QEMU
* Start QEMU from the `images` folder using
    ```
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
    ```
    Here we us the globally installed `qemu-system-arm`, but buildroot is also configured to build QEMU as host utility. If you want to use this version instead or QEMU is not installed globally, replace `qemu-system-arm` with `../host/bin/qemu-system-arm`
    
* Shutdown in guest system: Start guest with `-no-reboot` option and then in the guest you can run `poweroff`

* Manually bring up network in guest system
    ```
    ifconfig eth0 10.0.2.15 netmask 255.255.255.0
    route add default gw 10.0.2.2
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
    ```