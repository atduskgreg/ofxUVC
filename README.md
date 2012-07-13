## ofxUVC

An addon for controlling UVC (USB Universal Video Class) cameras. This lets you control things like the autoexposure and autofocus settings for your camera

Implementation is experimental. Only works on OS X for now, though is architected for cross-platform support (pull requests, welcome!).

*NOTE: On the Mac, [ofxQTKitVideoGrabber](https://github.com/Flightphase/ofxQTKitVideoGrabber) is required in placed of the standard ofVideoGrabber, which interferes with UVC control.*

There is a good thread on UVC control on the OF forum: [here](http://forum.openframeworks.cc/index.php/topic,3917.0.html). And an excellent post on the topic by Dominic Szablewski (from which the first draft of the Objective-C code here derives) [here](http://www.phoboslab.org/log/2009/07/uvc-camera-control-for-mac-os-x).

### Known Supported Cameras

* Microsoft LifeCam HD-3000

* Logitech C910

### Finding Your Camera's VendorId and DeviceId

Apple's Developer Tools ship with USB Prober: /Developer/Applications/Utilities/USB Prober.app

Launch USB Prober with your camera plugged in. Click the tab labeled "IORegistry". Find the IOUSBDevice for your camera and select it. Click the "Details" button, a pane will open off the top of the window. Scroll that pane until you find the "idProduct" and "idVendor" listings. You'll need those with the useCamera() function to connect to your camera.

### Thanks

[Dominic Szablewski](http://www.phoboslab.org/)

[James George](http://jamesgeorge.org) (for help hiding Cocoa from C++)