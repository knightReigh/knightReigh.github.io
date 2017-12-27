---
title: Install Arch Linux with Ubuntu and Windows
date: 2017-12-1
categories: ['programming']
tags:
  - Arch
  - Linux
  - UEFI
  - multiboot
  - KDE Plasma
  - Zsh
  - Vim
  - Linux Graphic Stack
  - sddm
  - Xorg
  - X11
  - Fctix
  - display server
  - window manager
  - display manager
  - Desktop Environment
  - Linux Partition
  - linux Chinese input
  - arch network configuration
---
# Before Start
I have had my Ubuntu + Windows dual-boot workstation set for quite while. Then I realize that I need an additional Linux installation in case my Work Ubuntu broke down. Since this **3rd** distro would be primarily used for resue and leisure experimentation, I choose [Arch Linux](https://www.archlinux.org/) for its high customizability and compact initial size.

<!-- more -->

Though I have installed Ubuntu/Mint/other more decorated distro million times, I foudn installing Arch linux rather interesting and refreshing. Since it starts with so few basic packages, you really get to know what packages are for what and how the kernel works behind the scene.

Few **warnings** beforehand:
+ Arch Linux installation requires **valid internet connection**

`there are ways to install without, but it is rather complicated`
+ Arch Linux requires turning off **secure boot** if you have it
+ You will not have graphical interface after valina installation
+ Always **back up** your important files and work in paritions allocated by existing OS (so you won't mess with existing data)

Some **exictiments** to look forward to:
+ Pair your base system with any `Desktop Environment (DE)` you like, wether it's KDE, Gnome, or XDFE
+ Choose your own `display manager`, such as lightdm, ssdm, xterm, etc
+ Get along with `pacman`, which is powerful and simplier than `apt-get`

Now let's begin.

# Disk configuration before install

| Partition | Description | Size | Type |
| --- | --- | --- | --- |
| The | bootloaders | ... | ... |
| sda1 | msft mbr partition | 472 MB | ntfs |
| sda2 | EFI bootloader | 105 MB  | fat32 |
| The | Windows | ... | ...  |
| sda3 | msft reserved | 16.8 MB | msftres |
| sda4 | Windows 10 | 214 GB | ntfs |
| sda5 | unknown | 1 GB | ntfs |
| The | Ubuntu | ... | ... |
| sda6 | Linux Swap | 10 GB | swap |
| sda7 | Ubuntu 17(/) | 70 GB | ext4 |
| sda8 | Ubuntu 17(/home) | 174 GB | ext4 |
| sda9 | Cross-OS Data | 215 GB | ntfs |
| Some  | free | space  | ... |

**Active Bootloader**: UEFI(sda2)

**Partition table**: gpt

**Data disk**: NTFS(sda9)

**Free space**: at end of disk

# Bootloader

> We are going to implement an **UEFI multiboot** system for our triple system configurations. The UEFI bootloader basically works as this: give UEFI bootloader one **single** partition; each OS will have one **directory** as one entry for bootloader with its own name under this UEFI partition. A detailed explanation can be found [here](https://unix.stackexchange.com/questions/160500/how-do-multiple-boot-loaders-work-on-an-efi-system-partition).

Since the disk already contains a Microsoft `mbr bootloader(sda1)` and a Linux `UEFI grub bootloader(sda2)`, with the UEFI bootloader being the active one, I will **not** create additional bootloader partition for Arch Linux and just **mount** the existing UEFI boot partition into `/boot`. Wait till reaching the [Install Arch Linux](#install-arch-linux) section.

*Note: my method works with `gpt` partition table and UEFI system. You will need to research for different combinations.*

*For more information: [Official Boot Guide](https://wiki.archlinux.org/index.php/Arch_boot_process)*

&nbsp;
<center><i>Now I have introduced some necessary backgrounds and concepts, it is prompt to proceed to the install methodology. First, we will look at the preparation steps.</i></center>
&nbsp;


# Preparation
## Create Live-USB

[Download](https://www.archlinux.org/download/)

It is recommened by [official docs](https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_GNU.2FLinux) to use `dd` command to create live-usb. `dd` will destroy any data on your usb so make sure to use the correct device.

(do **not** append partition number such as `sda1`, just use `sda`)

`# dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress && sync
`

However, my drive created with `dd` does not boot correctly, so I used [etcher](https://etcher.io/) to create the live-usb. It might be your back-up solution.

## Turn off Secure Boot
`Secure boot` might be the most redundant function added by Microsoft, aside from forcing automatic updates. It adds a lot of complication to the booting sequence and creates problems for unsigned binaries from other OS. The Arch installer will **not** work with secure boot by default. So I will just disable it. If you are interested maintaining it, there is an entire [article](https://wiki.archlinux.org/index.php/Secure_Boot) on how-tos.

Depending on your motherboard, the Secure Boot might require different methods to be turned off.

For my `ASUS` laptop, I do

1. Enter BIOS settings by press `F2`
2. Go to `Secure` settings
3. Choose `Delete all keys`
4. Save & Exits

Additional refs: [Microsoft](https://technet.microsoft.com/en-us/library/dn481258.aspx),[ How-to-Geek](https://www.howtogeek.com/175641/how-to-boot-and-install-linux-on-a-uefi-pc-with-secure-boot/), [Qualityology](https://www.qualityology.com/tech/disable-asus-motherboards-uefi-secure-boot/)

You can also turn off `fast boot`, which is not requried though.

## Boot into Live-USB

After loading finished, you should be logged in as: `root@archiso`

## WIFI configuration
As I warned you, Arch Linux requires valid **internet connection** throughout installation. I did not understand why though people are saying things like

`You will not be able to see the benefits of Arch Linux without a consistent internet connection.`

Well, at least this is an [official way](https://wiki.archlinux.org/index.php/offline_installation_of_packages) to install without internet, which adds more trouble. So we will stick with internet; anyways you will need to learn setting up internet in the non-graphical terminal to install your DE and internet manager later.

**So, let's start**.

The official wireless configuration guide is [here](https://wiki.archlinux.org/index.php/Wireless_network_configuration). I will just extract the key steps admist all those details and explanations (worthy reading though).

**Used packages**: `iw`, `wpa_supplicant` and `dhcpcd`

**3 Steps**:

0. Check ***driver status***: `lspci -k`

1. Configure ***wireless interface***:

    1. Get interace name: `iw dev` -> `interface: wlps20/wlan0`

    2. Get link status: `iw dev interface link`

    3. Activate interface: `ip link set interface up`

    4. Check interface status: `ip link show interface` -> `wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP>`. The `UP` means the interface is up.
2. Configure ***access point***:

    > The access point is basically each of the wifi SSIDs you see in either Windows or Ubuntu network manager.

    1. Scan for SSIDs: `iw dev interface scan | less` -> `your SSID`

    2. Connect to the SSID: `wpa_supplicant -B -i interface -c <(wpa_passphrase MYSSID passphrase)` -> `Successfully initialized wpa_supplicant`

    > wpa_passphrase generates a minimal configuration text block used by wpa_supplicant.

3. Get an ***IP address***

    `dhcpcd wlan0`


That's all you need to do. I won't bother turning it off since you need internet throughout the installation.

Update: you can use `wifi-menu`, which is much simpler.

Again, for any questions, read the [official doc](https://wiki.archlinux.org/index.php/Wireless_network_configuration#Check_the_driver_status).

## Partitioning
Now it's time to set up your disk space.

For basic installation, Arch only requires `/` partition and `bootloader` partition. `swap` partition is optional but recommended. Separate `/home`, `/software` and other schemes are just of your own choice.

[Official Paritioning Guide](https://wiki.archlinux.org/index.php/Partitioning#Partitionless_disk)

[Official File System Guide](https://wiki.archlinux.org/index.php/File_systems#Create_a_file_system)

In my case, I want to **share** the `UEFI bootloader` and `linux swap` partitions that have been set by the old Ubuntu. So all I need to do is to create a new partition `sda10` (40 GB) for Arch Linux and mount the existing `sda2` and `sda6` partition as `/boot` and `/swap` respectively. Refer to this [table](#disk-configuration-before-install) for the old disk configuration again.

The new partition can either be created before running the live-usb or during the installation process.

Useful utitlies: `parted/gparted`, `fdisk`

A simple example to create partition within the live-usb:

1. Enter `parted` interface: `parted` -> `(parted)`
2. Check partitions: `(parted) print`

    You should see something like this:

    `Disk /dev/sda: 100GB`

    `Partition Table: gpt`

    `Disk Flags:`

    | Number | Start | End | Size | Type | File System | Flags |
    | --- | --- | --- | --- | --- | --- | --- |
    | 1 | 100kB | 10GB | 9999MB | primary | ext4 | lba |

3. Create new partition: `(parted) mkpart`
4. Quit (do **not** format yet): `(parted) quit`

# Install Arch Linux

## Format new partition:

Check again: `lsblk /dev/sda`

Format Arch parition: `mkfs.ext4 /dev/sda10`

Turn on swap partition (existing): `swapon /dev/sda6`

*Remember the `swap` and `boot` partitions already exist. If not: refer to [use parted](https://www.tecmint.com/parted-command-to-create-resize-rescue-linux-disk-partitions/) and [Arch Install Notes](http://www.leyar.me/installation-of-archlinux/) on how-tos.*

## Mount necessary partitions

`mkdir /mnt` (create mount point)

`mount /dev/sda10 /mnt` (mount `/` partition)

`mkdir /mnt/boot` (create boot location)

`mount /dev/sda2 /mnt/boot` (mount `/boot` partition)

## Select mirror image

`vi /etc/pacman.d/mirrorlist`

**Uncomment** the ones you want to use and put them on **top** of the list for speed.

Use `pacman -Syy` to refresh after saving file.

## Install base packages

`pacstrap -i /mnt base base-devel`

## Generate file system table(Fstab)

`genfstab -U -p /mnt >> /mnt/etc/fstab`

Check: `vi /mnt/etc/fstab`

## Change the root into new system

`arch -chroot /mnt /bin/bash`

## System configuration(basic)

### Locale
`vi /etc/locale.gen`

Uncomment needed entries such as `en_US.UTF-8 UTF-8` and `zh-CN.UTF-8 UTF-8`

Generate locale file: `locale-gen`

Add `LANG=en_US.UTF-8` to `/etc/locale.conf` to set `LANG` variable.

### Timezone
`ln -sf /usr/share/zoneinfo/Region/City /etc/localtime`

### Hostname
Add your *hostname* to `vi /etc/hostname`

Consider adding entries to `/etc/hosts`

```
127.0.0.1	  localhost.localdomain	  localhost
::1         localhost.localdomain	  localhost
127.0.1.1	  myhostname.localdomain  myhostname
```

### Network configuration
The newly installed system has **no network**. Our previous configuration is with the live-usb only (we are still on it). And the valina Arch does **not** have packages such as `iw` and `wpa_supplicant` installed. So if you just leave now and boot into the new system, you will not be able to connect to internet(at least not very convinient).

So what is needed is to configure the internet(wireless or wired) now.

For wireless configuraton, follow the previous [section](#wifi-configuration). Basically, you install `iw` and `wpa_supplicant` packages while connected through the live-usb environment. You can also install `dialog` package if you choose to use `wifi-menu` instead.

For other configuration options, check the [official network manager guide](https://wiki.archlinux.org/index.php/Network_configuration#Network_managers).

### Root password
`passwd`

### Bootloader (optional)

If you already have another bootloader installed from previous linux distros, do not install another one!

If not, check this [page](https://wiki.archlinux.org/index.php/Category:Boot_loaders) for information.

A simple procedure to set up new bootloader focusing on **BIOS** + **GRUB** is like this:

```
pacman -S grub # install grub
grub-install --target=i386-pc --recheck /dev/sda
pacman -S os-prober # check existing OS on hard disks
grub-mkconfig -o /boot/grub/grub.cfg # generate grub entries
update-grub # (optional)
```

### Reboot
`exit`
`reboot`

### Some post-installation setup

**Install zsh**:

`pacman -S zsh`

**Create new users**:

`useradd -m -g users -G wheel, video, audio, floppy, network, rfkill, scanner, storage, optical, power, uucp -s /bin/bash newusername` (note: do not use `/usr/bin/bash` as the official installation guide points out)

`passwd newusername`

**Install and configure sudo package**:

`pacman -S sudo`

`vi /etc/sudoers # edit the sudo conf file`

uncomment the line to add all users belonging to the `wheel` group to the sudoers group

`%wheel ALL=(ALL) ALL`


## Arch Installation Conclusion

The previous sections describes **how to install a valina Arch linux distro on a Ubuntu-Windows dual booting hard drive with existing UEFI GRUB bootloader** and **sharing the current bootloader and SWAP partitions**.

The key is to **mount existing UEFI boot partition and swap partition into the new Arch installation**, and **do NOT install additional bootloader**.

Also remember to **configure network** for the new Arch **before reboot**.

### But what happens if you forget to configure internet
and cannot connect to your WIFI in the new Arch? Don't worry, just reboot into the live-usb, connect to wifi here and `mount /dev/sdxx /mnt` to install missing packages.

This is also the case if you forget or break other base packages in your new Arch system.

## Reference
1. [Archlinux 安装笔记 (highly recommened)](http://www.leyar.me/installation-of-archlinux/)
2. [Official Installation Guide (highly recommended)](https://wiki.archlinux.org/index.php/Installation_guide)
3. [Arch Linux Installation and Configuration on UEFI Machines](https://www.tecmint.com/arch-linux-installation-and-configuration-guide/)
4. [Archlinux 安装教程](http://blog.lucode.net/linux/archlinux-install-tutorial.html)
5. [ArchLinux 安装笔记](http://blog.lucode.net/linux/archlinux-install-tutorial.html)

&nbsp;

<center><i>Now the valina Arch linux has been installed and you should be able to see its name appearing on the boot entries. But this new Linux does not have any graphical environment and everything you want to do has to be done in a cumbersome way with bash such as connecting to the internet. So, the next section is to install a dispalay manager, a desktop environment and a network manager with GUI that are suitable for a human to use. </i></center>

&nbsp;

# Install KDE Plasma Desktop Environment
## Presequisite: Xorg, X11, Wayland, SDDM, KDE, Plasma, etc
So in order to install and run KDE Plasma successfully, we have to install some presequisite packages. These pacakges have similar names, a lot of alternatives, classified into ambiguous concepts; some of them even happen to be dependencies of each other.

Thus it is very confusing at first by just looking at some guides and Stackoverflow on how-to-install. These guides will likely to work, or not, depending on the default pacakges included in the valina Arch linux. Therefore, I researched a little more into those required packages, and attempts to generate a more thorough understanding both in concepts and methodology. If you see anything wrong or mis-leading, please let me know in the comment area. It's still a learning process.

**So, let's talk concepts**.

What all those packages trying to do, is to contribute to a **graphical user interface (GUI)** on top of non-graphical Linux kernels.  This interface connects user inputs (display, keyboard, audio) from each application that requires rendering service (**client**) and **kernel** instructions, which ultimately communicates with **hardware**. The interface follows standards, or **protocals**([ref]([ref2](https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/inside-linux-graphics-paper.pdf))).

A **display server** is an application that provides services for creating this GUI. The **Xorg** server uses **X11** protocal, abbreviated also as **X Window System** or just **X**([ref1](https://wiki.gentoo.org/wiki/Xorg/Guide),[ref2](http://blog.mecheye.net/2012/06/the-linux-graphics-stack/)).

A **window manager** is a X client that controls the appearance and behaviour of the frames where other graphical applications are drawn. It can be part of a desktop environment or used standalone ([ref](https://wiki.archlinux.org/index.php/Window_manager)).It is sometimes a **dependency** for some display servers to function properly.

{% asset_img Linux_graphical_scheme.png Linux_graphical_scheme %}

A **display manager/login manager** provides a graphical interface for log-in screen. It is considered the **first** X client at the end of boot process. It replaces the default text terminal session. **SDDM** and **LightDM** are examples of it.

Finally, a **Desktop Environment** is a complete collection of not only a graphical interface, but also programs written with the same set of toolkit and rules(clients), and of many useful libraries. The usual examples of DE on Linux/Unit are Gnome, KDE, XFCE, Cinnamon etc.

A special note for X server: It not only manages the local GUI, but also provides remote management.

{% asset_img X_graphical_scheme.png X_graphical_scheme %}

&nbsp;

**Now, after clearing the concepts, let's talk about installing the X server + KDE DE**.

## Install KDE Plasma
1. Install proper **graphic card driver**

    `pacman -S mesa xf86-video-intel # intel card`

    [additional driver info](https://wiki.archlinux.org/index.php/xorg#Driver_installation)

2. Install **Xorg**

    `pacman -S xorg--server xorg-xinit xorg-xauth xterm`

    [xorg-server](https://wiki.archlinux.org/index.php/xorg#Driver_installation) provides the x service.

    [xinit](https://wiki.archlinux.org/index.php/Xinit) provides easier startup configuration at `~/.xinitrc`.

    [xterm](https://wiki.archlinux.org/index.php/Xterm) might be needed for proper xorg function (not 100% sure).

    [xauth](http://jlk.fjfi.cvut.cz/arch/manpages/man/xauth.1.en) is required for xsession authentication.

    `Config file: /etc/X11/xinit/xinitrc`

3. Install **sddm** display Manager

    `pacman -S sddm sddm-kcm`

4. Enable `sddm` for graphical login

    1. `systemctl enable sddm`

    2. `/etc/systemd/system/display-manager.service: symbolic link to /usr/lib/systemd/system/sddm.service`

5. Install **Plasma DE**

    `pacman -S plasma-meta`


6. Configure `sddm` for Plasma

   ```
   sddm config file: /etc/sddm.conf
   comment out UserAuthFile=.Xauthority
   ```

   `remove ~/.Xauthority`

7. Install **network manager**

    `pacman -S networkmanager`

7. Reboot

# Bonus1: Install Chinese Input Method (Fctix)

1. Install **Fctix**
2. Install **Fctix-googlepinyin**
3. Add entries to **~/.xprofile**

    ```
    export QT_IM_MODULE=fcitx
    export GTK_IM_MODULE=fcitx
    ```

4. Log out and log in
5. Set `default keyboard layout` to `US` in `Configure`

# Bonus2: Install zsh/vim configuration

  The **ultimate vim vimrc** at [spf13/spf13-vim](https://github.com/spf13/spf13-vim)

  The **Oh My Zsh framework** at[robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

  *Small tricks on `~/.vimrc`*:

  1. Allow mouse copy: change `set mouse=a` to `set mouse=r`
  2. Toggle line-number: add `nnoremap <F2> :set nonumber!<CR>`
  3. Code folding shortcut: `<leader>f<level>` (example: `<leader>f0`)
  4. The `<leader>` key is mapped to `,`
