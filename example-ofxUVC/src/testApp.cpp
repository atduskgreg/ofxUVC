#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    
    yaml.load("camera_settings.yml");
    
    int cameraToUse;
    yaml.doc["cameraToUse"] >> cameraToUse;
    
    int vendorId, productId, interfaceNum;
    yaml.doc["cameras"][cameraToUse]["vendorId"] >> vendorId;
    yaml.doc["cameras"][cameraToUse]["productId"] >> productId;
    yaml.doc["cameras"][cameraToUse]["interfaceNum"] >> interfaceNum;
    yaml.doc["cameras"][cameraToUse]["name"] >> cameraName;
    yaml.doc["cameras"][cameraToUse]["width"] >> camWidth;
    yaml.doc["cameras"][cameraToUse]["height"] >> camHeight;
    
    vidGrabber.initGrabber(camWidth, camHeight);
    
    int deviceId = 0;
    vector<string> availableCams = vidGrabber.listVideoDevices();

    for(int i = 0; i < availableCams.size(); i++){
        if(availableCams.at(i) == cameraName){
            deviceId = i;
        }
    }
    
    vidGrabber.setDeviceID(deviceId);
       
    focus = 0.5;
    
    uvcControl.useCamera(vendorId, productId, interfaceNum); 
    uvcControl.setAutoExposure(true);
    controls = uvcControl.getCameraControls();
    
}

//--------------------------------------------------------------
void testApp::update(){
    vidGrabber.update();
    if(vidGrabber.isFrameNew())
    {
        tex.loadData(vidGrabber.getPixelsRef());
    }
    controls = uvcControl.getCameraControls();
}

//--------------------------------------------------------------
void testApp::draw(){
    ofBackground(0);
    tex.draw(0,0, camWidth, camHeight);

    ofSetColor(255);
    stringstream s;
    s << "Camera name: " << cameraName << "\nAuto-exposure: " << uvcControl.getAutoExposure() << "\nAuto-focus: " << uvcControl.getAutoFocus() <<
    "\nAbsolute focus: " << uvcControl.getAbsoluteFocus() <<
    "\nPress 'e' to toggle auto-exposure.\nPress 'f' to toggle auto-focus.\nPress +/- to set absolute foucs.\n\nResult of GET_STATUS for each feature\non this camera:\n";
        
    
    for(int i = 0; i < controls.size(); i++){
    
        s << controls.at(i).name << ": " << controls.at(i).status << "\n";

    }
    
    
    ofDrawBitmapString(s.str(), 650, 10);

}

void testApp::exit(){
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    if(key == 'e'){
        uvcControl.setAutoExposure(!uvcControl.getAutoExposure());
    }
    
    if(key == 'f'){
        uvcControl.setAutoFocus(!uvcControl.getAutoFocus());
    }
    
    if(key == '='){
        focus += 0.1;
        uvcControl.setAbsoluteFocus(focus);
    }
    
    if(key == '-'){
        focus -= 0.1;
        uvcControl.setAbsoluteFocus(focus);

    }
}

//--------------------------------------------------------------
void testApp::keyReleased(int key){

}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y){

}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ 

}