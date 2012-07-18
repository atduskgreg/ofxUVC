#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	vidGrabber.initGrabber(640*2, 480*2);
    
    // Built-in iSight
    //uvcControl.useCamera(0x5ac,0x8507, 0x00);

    
    // Logitech c910:
    //uvcControl.useCamera(0x046d,0x821, 0x02);

    // Logitech c6260
    //uvcControl.useCamera(0x046d,0x81a, 0x00);
    
    // Rosewill
    //uvcControl.useCamera(0x603,0x8b08, 0x00);

    // Microsoft LifeCam-VX700
    // correct vendorId and productId but no-worky
    //uvcControl.useCamera(0x45e,0x770, 0x00);


    // Encore Electronics ENUCM-013 (mysterious death sphere)
    //uvcControl.useCamera(0x1e4e,0x103, 0x00);

    // Inland
    //uvcControl.useCamera(0xc45,0x6340, 0x03);
    
    focus = 0.5;
    
    // Microsoft Lifecam HD-3000:
    uvcControl.useCamera(0x045e,0x779, 0x00);
 
    uvcControl.setAutoExposure(false);
    controls = uvcControl.getCameraControls();
    
}

//--------------------------------------------------------------
void testApp::update(){
    vidGrabber.update();
    controls = uvcControl.getCameraControls();
}

//--------------------------------------------------------------
void testApp::draw(){
    ofBackground(0);
	vidGrabber.draw(0,0, 640, 480);
    
    ofSetColor(255);
    stringstream s;
    s << "Auto-exposure: " << uvcControl.getAutoExposure() << "\nAuto-focus: " << uvcControl.getAutoFocus() <<
    "\nAbsolute focus: " << uvcControl.getAbsoluteFocus() <<
    "\nPress any key to toggle auto-exposure.\n\nResult of GET_STATUS for each feature\non this camera:\n";
        
    
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