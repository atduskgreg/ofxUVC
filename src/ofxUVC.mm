#include "ofxUVC.h"
#include "UVCCameraControl.h"

ofxUVC::ofxUVC(){
    cameraInited = false;
}

void ofxUVC::useCamera(int vendorId, int productId, int _interfaceNum){
	cameraControl = [[UVCCameraControl alloc] initWithVendorID:vendorId productID:productId interfaceNum:_interfaceNum];
    cameraInited = true;
}

ofxUVC::~ofxUVC(){
    if(cameraInited){
        [cameraControl release];
    }
}

void ofxUVC::setAutoExposure(bool enable){
    if(enable){
        [cameraControl setAutoExposure:YES];
    } else {
        [cameraControl setAutoExposure:NO];
    }
}

bool ofxUVC::getAutoExposure(){
    return [cameraControl getAutoExposure];
}

void ofxUVC::setExposure(float value){
    [cameraControl setExposure:value];
}

float ofxUVC::getExposure(){
    return [cameraControl getExposure];
}

void ofxUVC::setAutoFocus(bool enabled){
    [cameraControl setAutoFocus:enabled];
}

bool ofxUVC::getAutoFocus(){
    return [cameraControl getAutoFocus];
}

void ofxUVC::setAbsoluteFocus(float value){
    [cameraControl setAbsoluteFocus:value];
}

float ofxUVC::getAbsoluteFocus(){
    return [cameraControl getAbsoluteFocus];
}

void ofxUVC::setAutoWhiteBalance(bool enabled){
    [cameraControl setAutoWhiteBalance:enabled];
}

bool ofxUVC::getAutoWhiteBalance(){
    return [cameraControl getAutoWhiteBalance];
}

void ofxUVC::setWhiteBalance(float value){
    [cameraControl setWhiteBalance:value];
}

float ofxUVC::getWhiteBalance(){
    return [cameraControl getWhiteBalance];
}

void ofxUVC::setGain(float value){
    [cameraControl setGain:value];
}

float ofxUVC::getGain(){
    return [cameraControl getGain];
}

void ofxUVC::setBrightness(float value){
    [cameraControl setBrightness:value];
}

float ofxUVC::getBrightness(){
    return [cameraControl getBrightness];
}

void ofxUVC::setContrast(float value){
    [cameraControl setContrast:value];
}

float ofxUVC::getContrast(){
    return [cameraControl getContrast];
}

void ofxUVC::setSaturation(float value){
    [cameraControl setSaturation:value];
}

float ofxUVC::getSaturation(){
    return [cameraControl getSaturation];
}

void ofxUVC::setSharpness(float value){
    [cameraControl setSharpness:value];
}

float ofxUVC::getSharpness(){
    return [cameraControl getSharpness];
}


vector<ofxUVCControl> ofxUVC::getCameraControls(){
    vector<ofxUVCControl> result;
    
    ofxUVCControl autoFocus;
    autoFocus.name = "autoFocus";
    autoFocus.status = [cameraControl getInfoForControl:&[cameraControl getControls]->autoFocus];
    result.push_back(autoFocus);
    
    ofxUVCControl autoExposure;
    autoExposure.name = "autoExposure";
    autoExposure.status = [cameraControl getInfoForControl:&[cameraControl getControls]->autoExposure];
    result.push_back(autoExposure);
    
	ofxUVCControl exposure;
    exposure.name = "exposure";
    exposure.status = [cameraControl getInfoForControl:&[cameraControl getControls]->exposure];
    result.push_back(exposure);
    
	ofxUVCControl absoluteFocus;
    absoluteFocus.status = [cameraControl getInfoForControl:&[cameraControl getControls]->focus];
    //absoluteFocus.status = [cameraControl getInfoForControl:&[cameraControl getControls]->absoluteFocus];
    result.push_back(absoluteFocus);

	ofxUVCControl focus;
    focus.name = "focus";
    focus.status = [cameraControl getInfoForControl:&[cameraControl getControls]->focus];
    result.push_back(focus);
    
	ofxUVCControl brightness;
    brightness.name = "brightness";
    brightness.status = [cameraControl getInfoForControl:&[cameraControl getControls]->brightness];
    result.push_back(brightness);
    
	ofxUVCControl contrast;
    contrast.name = "contrast";
    contrast.status = [cameraControl getInfoForControl:&[cameraControl getControls]->contrast];
    result.push_back(contrast);
    
	ofxUVCControl gain;
    gain.name = "gain";
    gain.status = [cameraControl getInfoForControl:&[cameraControl getControls]->gain];
    result.push_back(gain);
    
	ofxUVCControl saturation;
    saturation.name = "saturation";
    saturation.status = [cameraControl getInfoForControl:&[cameraControl getControls]->saturation];
    result.push_back(saturation);
    
	ofxUVCControl sharpness;
    sharpness.name = "sharpness";
    sharpness.status = [cameraControl getInfoForControl:&[cameraControl getControls]->sharpness];
    result.push_back(sharpness);
    
	ofxUVCControl whiteBalance;
    whiteBalance.name = "whiteBalance";
    whiteBalance.status = [cameraControl getInfoForControl:&[cameraControl getControls]->whiteBalance];
    result.push_back(whiteBalance);
    
	ofxUVCControl autoWhiteBalance;
    autoWhiteBalance.name = "autoWhiteBalance";
    autoWhiteBalance.status = [cameraControl getInfoForControl:&[cameraControl getControls]->autoWhiteBalance];
    result.push_back(autoWhiteBalance);
    
  //  ofxUVCControl incremental_exposure;

    return result;
}
