+++
Categories = ["Development", "VMWare"]
Description = ""
Tags = ["Development", "vmware"]
date = "2012-10-16T12:14:52-04:00"
title = "VMware Workstation Ubuntu problems"

+++

I just tried starting up vmware workstation and was greeted with a message saying it needed to compile some modules and then went on to fail this step no matter what. This is an issue I've encountered before on Ubuntu 11.04 and now on 11.10.

This is a bug with all v7.x of workstation and can be fixed with a simple patch I found today at http://weltall.heliohost.org/wordpress/2011/05/14/running-vmware-workstation-player-on-linux-2-6-39-updated/

How to use it:

``` sh
mkdir ~/Downloads/patchv3
cd ~/Downloads/patchv3/
wget http://weltall.heliohost.org/wordpress/wp-content/uploads/2011/05/vmware2.6.39patchv3.tar.bz2
tar -xvf vmware2.6.39patchv3.tar.bz2
chmod +x patch-modules_2.6.39.sh
sudo ./patch-modules_2.6.39.sh
```
