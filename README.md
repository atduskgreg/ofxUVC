## ofxUVC

An addon for controlling UVC (USB Universal Video Class) cameras. This lets you control things like the autoexposure and autofocus settings for your camera

Implementation is experimental. Only works on OS X for now, though is architected for cross-platform support (pull requests, welcome!).

*NOTE: On the Mac, [ofxQTKitVideoGrabber](https://github.com/Flightphase/ofxQTKitVideoGrabber) is required in placed of the standard ofVideoGrabber, which interferes with UVC control.*

There is a good thread on UVC control on the OF forum: [here](http://forum.openframeworks.cc/index.php/topic,3917.0.html). And an excellent post on the topic by Dominic Szablewski (from which the first draft of the Objective-C code here derives) [here](http://www.phoboslab.org/log/2009/07/uvc-camera-control-for-mac-os-x).

### Known Supported Cameras

* Microsoft LifeCam HD-3000

* Logitech C910

* Encore Electronics ENUCM-013

* Rosewill

* Logitech c6260

### UVC Test App

This repo also includes a Mac app for testing the UVC support of your camera: [uvc_test_app](https://github.com/atduskgreg/ofxUVC/downloads). This app pulls vendorId, productId, and interfaceNum values from a YAML file (data/camera_settings.yml in the download). To select your camera, change the cameraToUse value in that YAML file to point at your camera. If your camera is not listed there, you can discover its settings using the instructions below and add them to the YAML file manually. If you do so, please submit a pull request or otherwise contribute them here.

### Finding Your Camera's VendorId and ProductId

Apple's Developer Tools ship with USB Prober: /Developer/Applications/Utilities/USB Prober.app

Launch USB Prober with your camera plugged in. Click the tab labeled "IORegistry". Find the IOUSBDevice for your camera and select it. Click the "Details" button, a pane will open off the top of the window. Scroll that pane until you find the "idProduct" and "idVendor" listings. You'll need those with the useCamera() function to connect to your camera.

### Thanks

[Dominic Szablewski](http://www.phoboslab.org/)

[James George](http://jamesgeorge.org) (for help hiding Cocoa from C++)

### License

ofxUVC is licensed under an MIT License

The MIT License (MIT)

Copyright (c) 2011 Greg Borenstein

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
