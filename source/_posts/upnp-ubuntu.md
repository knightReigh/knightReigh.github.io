---
title: Set up Home Streaming Library on Ubuntu (UPNP)
date: 2017-12-21 01:49:18
categories: ['programming']
tags:
  - linux
---

{% asset_img logo-horiz.png  %}

I found this spin-off of *[MediaTomb](http://mediatomb.cc/)* most straight-forward and user-friendly to set up a **UPNP streaming library** on Ubunu/Linux systems.

<!-- more -->

## Features

+ It provides a web user interface where users can just click to add custom libraries. 
+ The command line interface shows detailed information such as scanning process; so you won't be cluseless.
+ No set-up is required after installing. Just run `gerbera` and you are good to go.
+ I have tested with `VLC` and `UPNP Xtreme` on my ipad. It works great. 
+ And it is actively developed. 

## Installation

Visit [Git](https://github.com/gerbera/gerbera) page and follow instructions per distribution. You can also compile from source.

## Other UPNP options

+ [minidlna](https://mylinuxramblings.wordpress.com/2016/02/19/mini-how-to-installing-minidlna-in-ubuntu/)

    This seems to be the most popular upnp package on linux. It claims to be lightweight, stable and semi-actively-maintained. But I can't get it to work. Basically it runs and shows up in upnp clients. But it does not scan my custom media folders. I probably have the set-up wrong somewhere. But I didn't find any solution yet.

+ [rygel](https://wiki.gnome.org/Projects/Rygel)

    Anothe popular package. It is easier to use than minidlna because it comes with a graphical preference interface. It has some plugins so I assume the extensibility is better. I get my custom media folder scanned alright. But the ipad-version `VLC` and other media players cannot find any content from its server. `UPNP Xtreme` works alright with it.
