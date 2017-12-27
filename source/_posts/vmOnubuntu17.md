---
title: A Simple Solution For Virtual Box Usage on Ubuntu/Debian 16.04 with Secure Boot
date: 2017-09-09 00:00
categories: ['Linux']
tags:
  - Linux
---

There are numerous cases in which an attempt to run virtualbox package on a Ubuntu/Debian machine fail. One of the cases has something to do with the way new Debian deals with secure boot loader, which is an unavoidable object for current machines, especially when you need a Windows/Linux dual-boot system. A simple and elegant solution for such case has been drafted by [Android Dev](https://askubuntu.com/users/518562/android-dev) at [askubuntu](askubuntu.com). And I take the liberty to quote it here primarily for my own reference.
 
<!-- more -->

# Sympton
```
Virtual box is installed on Ubuntu 16.04 with secure boot enabled 
Error when loading `vboxdrv` kernel module by running virtualbox 
Run `\'sudo /sbin/vboxconfig\'` as required
Error: `vboxdrv.sh: failed: modprobe vboxdrv failed. Please use 'dmesg' to find out why.` 
```
# Diagnostic
*As quoated from [Android Dev](https://askubuntu.com/questions/900118/vboxdrv-sh-failed-modprobe-vboxdrv-failed-please-use-dmesg-to-find-out-why):*

> "The problem is the requirement that all kernel modules must be signed by a key trusted by the UEFI system, otherwise loading will fail. Ubuntu does not sign the third party vbox* kernel modules, but rather gives the user the option to disable Secure Boot upon installation of the virtualbox package. I could do that, but then I would see an annoying “Booting in insecure mode” message every time the machine starts, and also the dual boot Windows 10 installation I have would not function."

*Extra credit goes to: [VBox & VMware in SecureBoot Linux (2016 Update)](https://gorka.eguileor.com/vbox-vmware-in-secureboot-linux-2016-update/)*

# Solution
*As COMPLETELY quoated from [Android Dev](https://askubuntu.com/questions/900118/vboxdrv-sh-failed-modprobe-vboxdrv-failed-please-use-dmesg-to-find-out-why):*
```
1. Install the virtualbox package. If presented with the option to disable Secure Boot. Choose “No”. 
2. Create a personal public/private RSA key pair which will be used to sign kernel modules. The author chose to use the root account and the directory /root/module-signing/ to store all things related to signing kernel modules.

    $ sudo -i
    mkdir /root/module-signing
    cd /root/module-signing
    openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=YOUR_NAME/"
    ## YOUR_NAME = machine owner/user/etc

    [...]
    # chmod 600 MOK.priv

3. Use the MOK (“Machine Owner Key”) utility to import the public key so that it can be trusted by the system. This is a two step process where the key is first imported, and then later must be enrolled when the machine is booted the next time. A simple password is good enough, as it is only for temporary use.

    # mokutil --import /root/module-signing/MOK.der
    input password:
    input password again:

4. Reboot the machine. 
   The MOK manager EFI utility should automatically start with bootloader.  
   It will ask for parts of the password supplied in step 3.  
   Choose to `“Enroll MOK”`. 
   Complete the enrollment, then continue with the boot.  
   The Linux kernel will log the keys that are loaded, and you should be able to see your own key with the command:  `dmesg|grep 'EFI: Loaded cert'`

5. Using a signing utility shippped with the kernel build files, sign all the VirtualBox modules using the private MOK key generated in step 3.
   The author provided a script for it:`/root/module-signing/sign-vbox-modules` 
   It can be easily run when new kernels are installed as part of regular updates

    #!/bin/bash

    for modfile in $(dirname $(modinfo -n vboxdrv))/*.ko; do
    echo "Signing $modfile"
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
                                        /root/module-signing/MOK.priv \
                                       /root/module-signing/MOK.der "$modfile"
    done

    To authorize it: `chmod 700 /root/module-signing/sign-vbox-modules`

6. Run the script, and for every time a new kernel is updated.
7. Load vboxdrv module: `# modprobe vboxdrv`
```

<br><font size="2"> Again, complete courtesy to</font></br>
[Android Dev](https://askubuntu.com/questions/900118/vboxdrv-sh-failed-modprobe-vboxdrv-failed-please-use-dmesg-to-find-out-why)'s answer at [askubuntu](askubuntu.com).
