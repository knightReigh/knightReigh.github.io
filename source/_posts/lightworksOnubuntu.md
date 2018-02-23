---
title: Lightworks 14 Closes Immediately After Opening Ubuntu 17
date: 2018-02-23 00:00
categories: ['Linux']
tags:
  - Linux
  - video-editing
  - lightworks
---

Solution for Lightworks 14 closing immediately after opneing on Ubuntu 17.
 
<!-- more -->

# Download two libs from Ubuntu artful repo (.deb files)

+ libportaudio2
+ libportaudiocpp0

Choose amd64 (64 bit lightworks) and any mirror

# Extract .deb files

+ Extract here
+ Go to extracted folders
+ Extract data.tar.xz for each .deb file into a `data` folder

# Now you should have two files under each data folder

- libportaudiocpp.so.0 
- libportaudio.so.2
- libportaudiocpp.so.0.0.12
- libportaudio.so.2.0.0

# Copy these 4 files into /usr/lib/lightworks/

You are done.

**Note** You should use lightworks 14.1 beta version at least (not sure your newest version when you read this).

# Other usable video editing software on linux

Openshot, Pitivi

Neither of them support timeline rendering and visual cropping though. But they are free.
