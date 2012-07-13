#import "UVCCameraControl.h"


const uvc_controls_t uvc_controls = {
	.autoExposure = {
		.unit = UVC_INPUT_TERMINAL_ID,
		.selector = 0x02, //CT_AE_MODE_CONTROL
		.size = 1,
	},
	.exposure = {
		.unit = UVC_INPUT_TERMINAL_ID,
		.selector = 0x04, //CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
		.size = 4,
	},
    
    .incremental_exposure = {
		.unit = UVC_INPUT_TERMINAL_ID,
		.selector = 0x05, //CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
		.size = 1,
	},
	.absoluteFocus = {
		.unit = 0x09,
		.selector = 0x03,
		.size = 8,
	},	
	.autoFocus = {
		.unit = UVC_INPUT_TERMINAL_ID,
		.selector = 0x08, //CT_FOCUS_AUTO_CONTROL
		.size = 1,
	},
	.focus = {
		.unit = UVC_INPUT_TERMINAL_ID,
		.selector = 0x06, //CT_FOCUS_ABSOLUTE_CONTROL
		.size = 2,
	},
	.brightness = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x02,
		.size = 2,
	},
	.contrast = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x03,
		.size = 2,
	},
	.gain = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x04,
		.size = 2,
	},
	.saturation = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x07,
		.size = 2,
	},
	.sharpness = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x08,
		.size = 2,
	},
	.whiteBalance = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x0A,
		.size = 2,
	},
	.autoWhiteBalance = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x0B,
		.size = 1,
	},
};


@implementation UVCCameraControl


- (id)initWithLocationID:(UInt32)locationID {
	if( self = [super init] ) {
		interface = NULL;
		
		// Find All USB Devices, get their locationId and check if it matches the requested one
		CFMutableDictionaryRef matchingDict = IOServiceMatching(kIOUSBDeviceClassName);
		io_iterator_t serviceIterator;
		IOServiceGetMatchingServices( kIOMasterPortDefault, matchingDict, &serviceIterator );
		
		io_service_t camera;
		while( camera = IOIteratorNext(serviceIterator) ) {
			// Get DeviceInterface
			IOUSBDeviceInterface **deviceInterface = NULL;
			IOCFPlugInInterface	**plugInInterface = NULL;
			SInt32 score;
			kern_return_t kr = IOCreatePlugInInterfaceForService( camera, kIOUSBDeviceUserClientTypeID, kIOCFPlugInInterfaceID, &plugInInterface, &score );
			if( (kIOReturnSuccess != kr) || !plugInInterface ) {
				NSLog( @"CameraControl Error: IOCreatePlugInInterfaceForService returned 0x%08x.", kr );
				continue;
			}
			
			HRESULT res = (*plugInInterface)->QueryInterface(plugInInterface, CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID), (LPVOID*) &deviceInterface );
			(*plugInInterface)->Release(plugInInterface);
			if( res || deviceInterface == NULL ) {
				NSLog( @"CameraControl Error: QueryInterface returned %d.\n", (int)res );
				continue;
			}
			
			UInt32 currentLocationID = 0;
			(*deviceInterface)->GetLocationID(deviceInterface, &currentLocationID);
			
			if( currentLocationID == locationID ) {
				// Yep, this is the USB Device that was requested!
				interface = [self getControlInferaceWithDeviceInterface:deviceInterface];
				return self;
			}
		} // end while
		
	}
	return self;
}


- (id)initWithVendorID:(long)vendorID productID:(long)productID {
	if( self = [super init] ) {
		interface = NULL;
		
		// Find USB Device
		CFMutableDictionaryRef matchingDict = IOServiceMatching(kIOUSBDeviceClassName);
		CFNumberRef numberRef;
		
		numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &vendorID);
		CFDictionarySetValue( matchingDict, CFSTR(kUSBVendorID), numberRef );
		CFRelease(numberRef);
		
		numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &productID);
		CFDictionarySetValue( matchingDict, CFSTR(kUSBProductID), numberRef );
		CFRelease(numberRef);
		io_service_t camera = IOServiceGetMatchingService( kIOMasterPortDefault, matchingDict );
		
		
		// Get DeviceInterface
		IOUSBDeviceInterface **deviceInterface = NULL;
		IOCFPlugInInterface	**plugInInterface = NULL;
		SInt32 score;
		kern_return_t kr = IOCreatePlugInInterfaceForService( camera, kIOUSBDeviceUserClientTypeID, kIOCFPlugInInterfaceID, &plugInInterface, &score );
        if( (kIOReturnSuccess != kr) || !plugInInterface ) {
            NSLog( @"CameraControl Error: IOCreatePlugInInterfaceForService returned 0x%08x.", kr );
			return self;
        }
		
        HRESULT res = (*plugInInterface)->QueryInterface(plugInInterface, CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID), (LPVOID*) &deviceInterface );
        (*plugInInterface)->Release(plugInInterface);
        if( res || deviceInterface == NULL ) {
            NSLog( @"CameraControl Error: QueryInterface returned %d.\n", (int)res );
            return self;
        }
		
		interface = [self getControlInferaceWithDeviceInterface:deviceInterface];
	}
	return self;
}


- (IOUSBInterfaceInterface190 **)getControlInferaceWithDeviceInterface:(IOUSBDeviceInterface **)deviceInterface {
	IOUSBInterfaceInterface190 **controlInterface;
	
	io_iterator_t interfaceIterator;
	IOUSBFindInterfaceRequest interfaceRequest;
	interfaceRequest.bInterfaceClass = UVC_CONTROL_INTERFACE_CLASS;
	interfaceRequest.bInterfaceSubClass = UVC_CONTROL_INTERFACE_SUBCLASS;
	interfaceRequest.bInterfaceProtocol = kIOUSBFindInterfaceDontCare;
	interfaceRequest.bAlternateSetting = kIOUSBFindInterfaceDontCare;
	
	IOReturn success = (*deviceInterface)->CreateInterfaceIterator( deviceInterface, &interfaceRequest, &interfaceIterator );
	if( success != kIOReturnSuccess ) {
		return NULL;
	}
	
	io_service_t usbInterface;
	HRESULT result;
	
	
	if( usbInterface = IOIteratorNext(interfaceIterator) ) {
		IOCFPlugInInterface **plugInInterface = NULL;
		
		//Create an intermediate plug-in
		SInt32 score;
		kern_return_t kr = IOCreatePlugInInterfaceForService( usbInterface, kIOUSBInterfaceUserClientTypeID, kIOCFPlugInInterfaceID, &plugInInterface, &score );
		
		//Release the usbInterface object after getting the plug-in
		kr = IOObjectRelease(usbInterface);
		if( (kr != kIOReturnSuccess) || !plugInInterface ) {
			NSLog( @"CameraControl Error: Unable to create a plug-in (%08x)\n", kr );
			return NULL;
		}
		
		//Now create the device interface for the interface
		result = (*plugInInterface)->QueryInterface( plugInInterface, CFUUIDGetUUIDBytes(kIOUSBInterfaceInterfaceID), (LPVOID *) &controlInterface );
		
		//No longer need the intermediate plug-in
		(*plugInInterface)->Release(plugInInterface);
		
		if( result || !controlInterface ) {
			NSLog( @"CameraControl Error: Couldn’t create a device interface for the interface (%08x)", (int) result );
			return NULL;
		}
		
		return controlInterface;
	}
	
	return NULL;
}


- (void)dealloc {
	if( interface ) {
		(*interface)->USBInterfaceClose(interface);
		(*interface)->Release(interface);
	}
	[super dealloc];
}


- (BOOL)sendControlRequest:(IOUSBDevRequest)controlRequest {
	if( !interface ){
		NSLog( @"CameraControl Error: No interface to send request" );
		return NO;
	}
	
	//Now open the interface. This will cause the pipes associated with
	//the endpoints in the interface descriptor to be instantiated
	kern_return_t kr = (*interface)->USBInterfaceOpen(interface);
	if (kr != kIOReturnSuccess)	{
		NSLog( @"CameraControl Error: Unable to open interface (%08x)\n", kr );
		return NO;
	}
	
	kr = (*interface)->ControlRequest( interface, 0, &controlRequest );
	if( kr != kIOReturnSuccess ) {
		kr = (*interface)->USBInterfaceClose(interface);
		NSLog( @"CameraControl Error: Control request failed: %08x", kr );
		return NO;
	}
	
	kr = (*interface)->USBInterfaceClose(interface);
	
	return YES;
}


- (long) getInfoForControl:(uvc_control_info_t *)control{
    return [self getDataFor:UVC_GET_INFO withLength:1  fromSelector:control->selector at:control->unit];
    
}

- (BOOL)setData:(long)value withLength:(int)length forSelector:(int)selector at:(int)unitId {
	IOUSBDevRequest controlRequest;
	controlRequest.bmRequestType = USBmakebmRequestType( kUSBOut, kUSBClass, kUSBInterface );
	controlRequest.bRequest = UVC_SET_CUR;
	controlRequest.wValue = (selector << 8) | 0x00;
	controlRequest.wIndex = (unitId << 8) | 0x00;
	controlRequest.wLength = length;
	controlRequest.wLenDone = 0;
	controlRequest.pData = &value;
	return [self sendControlRequest:controlRequest];
}


- (long)getDataFor:(int)type withLength:(int)length fromSelector:(int)selector at:(int)unitId {
	long value = 0;
	IOUSBDevRequest controlRequest;
	controlRequest.bmRequestType = USBmakebmRequestType( kUSBIn, kUSBClass, kUSBInterface );
	controlRequest.bRequest = type;
	controlRequest.wValue = (selector << 8) | 0x00;
	controlRequest.wIndex = (unitId << 8) | 0x00;
	controlRequest.wLength = length;
	controlRequest.wLenDone = 0;
	controlRequest.pData = &value;
	BOOL success = [self sendControlRequest:controlRequest];
	return ( success ? value : 0 );
}


// Get Range (min, max)
- (uvc_range_t)getRangeForControl:(uvc_control_info_t *)control {
	uvc_range_t range = { 0, 0 };
	range.min = [self getDataFor:UVC_GET_MIN withLength:control->size fromSelector:control->selector at:control->unit];
	range.max = [self getDataFor:UVC_GET_MAX withLength:control->size fromSelector:control->selector at:control->unit];
	return range;
}


// Used to de-/normalize values
- (float)mapValue:(float)value fromMin:(float)fromMin max:(float)fromMax toMin:(float)toMin max:(float)toMax {
	return toMin + (toMax - toMin) * ((value - fromMin) / (fromMax - fromMin));
}


// Get a normalized value
- (float)getValueForControl:(uvc_control_info_t *)control {
	// TODO: Cache the range somewhere?
	uvc_range_t range = [self getRangeForControl:control];
	
	int intval = [self getDataFor:UVC_GET_CUR withLength:control->size fromSelector:control->selector at:control->unit];
	return [self mapValue:intval fromMin:range.min max:range.max toMin:0 max:1];
}


// Set a normalized value
- (BOOL)setValue:(float)value forControl:(uvc_control_info_t *)control {
	// TODO: Cache the range somewhere?
	uvc_range_t range = [self getRangeForControl:control];
	
	int intval = [self mapValue:value fromMin:0 max:1 toMin:range.min max:range.max];
	return [self setData:intval withLength:control->size forSelector:control->selector at:control->unit];
}





// ================================================================

// Set/Get the actual values for the camera
//

- (BOOL)setAutoExposure:(BOOL)enabled {
	int intval = (enabled ? 0x08 : 0x01); // "auto exposure modes" ar NOT boolean (on|off) as it seems
	printf("setAutoExposure = %i \n",enabled);
	return [self setData:intval 
			  withLength:uvc_controls.autoExposure.size 
			 forSelector:uvc_controls.autoExposure.selector 
					  at:uvc_controls.autoExposure.unit];
	
}

- (BOOL)getAutoExposure {
	int intval = [self getDataFor:UVC_GET_CUR 
					   withLength:uvc_controls.autoExposure.size 
					 fromSelector:uvc_controls.autoExposure.selector 
							   at:uvc_controls.autoExposure.unit];
	
	return ( intval == 0x08 ? YES : NO );
}

- (BOOL)setExposure:(float)value {
	printf("exposure value %f \n",value);
	value = 1 - value;
	return [self setValue:value forControl:&uvc_controls.exposure];
}

- (void) incrementExposure {
    [self setData:0x01 
       withLength:uvc_controls.exposure.size 
      forSelector:uvc_controls.exposure.selector 
               at:uvc_controls.exposure.unit];
}

- (void) decrementExposure {
    [self setData:0xFF
       withLength:uvc_controls.exposure.size 
      forSelector:uvc_controls.exposure.selector 
               at:uvc_controls.exposure.unit];
}

- (void) setDefaultExposure {
    [self setData:0x00
       withLength:uvc_controls.exposure.size 
      forSelector:uvc_controls.exposure.selector 
               at:uvc_controls.exposure.unit];
}

- (uvc_controls_t *) getControls{
    return &uvc_controls;
}



- (float)getExposure {
	float value = [self getValueForControl:&uvc_controls.exposure];
	return 1 - value;
}



//-----focus
- (BOOL)setAutoFocus:(BOOL)enabled {
	//int intval = (enabled ? 0x08 : 0x01); //that's how eposure does it
	int intval = (enabled ? 0x01 : 0x00); //that's how white balance does it
	printf("setAutoFocus = %i \n",enabled);
	return [self setData:intval 
			  withLength:uvc_controls.autoFocus.size 
			 forSelector:uvc_controls.autoFocus.selector 
					  at:uvc_controls.autoFocus.unit];
	
}
- (BOOL)getAutoFocus {
	int intval = [self getDataFor:UVC_GET_CUR 
					   withLength:uvc_controls.autoFocus.size 
					 fromSelector:uvc_controls.autoFocus.selector 
							   at:uvc_controls.autoFocus.unit];
	
	//return ( intval == 0x08 ? YES : NO );
	//return ( intval ? YES : NO );
	return ( intval == 0x01 ? YES : NO );
}
- (BOOL)setAbsoluteFocus:(float)value {
	printf("focus value %f \n",value);
	//value = 1 - value;
	return [self setValue:value forControl:&uvc_controls.focus];
	
}
- (float)getAbsoluteFocus {
	//float value = [self getValueForControl:&uvc_controls.absoluteFocus];
	//return 1 - value;
	return [self getValueForControl:&uvc_controls.focus];
}


//white balance
- (BOOL)setAutoWhiteBalance:(BOOL)enabled {
	int intval = (enabled ? 0x01 : 0x00);
	printf("setAutoWhiteBalance = %i \n",enabled);
	return [self setData:intval 
			  withLength:uvc_controls.autoWhiteBalance.size 
			 forSelector:uvc_controls.autoWhiteBalance.selector 
					  at:uvc_controls.autoWhiteBalance.unit];
	
}

- (BOOL)getAutoWhiteBalance {
	int intval = [self getDataFor:UVC_GET_CUR 
					   withLength:uvc_controls.autoWhiteBalance.size 
					 fromSelector:uvc_controls.autoWhiteBalance.selector 
							   at:uvc_controls.autoWhiteBalance.unit];
	
	return ( intval ? YES : NO );
}

- (BOOL)setWhiteBalance:(float)value {
	printf("whiteBalance value %f \n",value);
	return [self setValue:value forControl:&uvc_controls.whiteBalance];
}

- (float)getWhiteBalance {
	return [self getValueForControl:&uvc_controls.whiteBalance];
}

//---rest---

- (BOOL)setGain:(float)value {
	printf("gain value %f \n",value);
	
	return [self setValue:value forControl:&uvc_controls.gain];
}

- (float)getGain {
	return [self getValueForControl:&uvc_controls.gain];
}

- (BOOL)setBrightness:(float)value {
	printf("brightness value %f \n",value);
	return [self setValue:value forControl:&uvc_controls.brightness];
}

- (float)getBrightness {
	return [self getValueForControl:&uvc_controls.brightness];
}

- (BOOL)setContrast:(float)value {
	return [self setValue:value forControl:&uvc_controls.contrast];
}

- (float)getContrast {
	return [self getValueForControl:&uvc_controls.contrast];
}

- (BOOL)setSaturation:(float)value {
	return [self setValue:value forControl:&uvc_controls.saturation];
}

- (float)getSaturation {
	return [self getValueForControl:&uvc_controls.saturation];
}

- (BOOL)setSharpness:(float)value {
	return [self setValue:value forControl:&uvc_controls.sharpness];
}

- (float)getSharpness {
	return [self getValueForControl:&uvc_controls.sharpness];
}



@end
