# Recruitbot

A Project to make easily hackable robots that we can use for robotics competitions and teaching programming and robotics ideas.

# Setting Up A Bot

## Parts List

## Assembling Physical Components

## Preparing the Pi

__Setup Wifi Credentials__
Your Wifi credentials will depend on the network that you connect to.
We like to bring our own WiFi router to events and always try to configure out robots to connect to that router.
First you'll want to make sure that your `/etc/network/inerfaces` file looks like:

```
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

iface eth0 inet manual

allow-hotplug wlan0
iface wlan0 inet dhcp
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

This tells the pi to allow a USB Wifi module to be plugged/unplugged while it is running.
Next edit the `/etc/wpa_supplicant/wpa_supplicant.conf` file to look like:

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="pifi"
    psk="pifipifi"
    priority=5
}

network={
    ssid="development_wifi"
    psk="some-other-password"
    priority=2
}
```

Here we have setup two different WiFi credentials.
The `development_wifi` will be preferred (higher priority) and the `pifi` network will be used when that is unavailable.
Now on your raspberry-pi terminal you can run `sudo ifup wlan0` and it should load the configuration and try to connect to the wifi.

## Loading the Software
