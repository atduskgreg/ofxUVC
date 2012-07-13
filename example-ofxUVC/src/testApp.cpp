#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	vidGrabber.initGrabber(1280/2, 720/2);
        
    uvcControl.useCamera(0x045e,0x779);
    uvcControl.setAutoExposure(false);
    controls = uvcControl.getCameraControls();
    
    cout << "3 & 0x00000100 = " << ((unsigned int)3 & 0x00000100) << "\n15 & 0x00000100 = " << ((unsigned int)15 & 0x00000100) << "\n15 & 0x00100000 = " << ((unsigned int)15 & 0x00100000) <<endl;
    
}

//--------------------------------------------------------------
void testApp::update(){
    vidGrabber.update();
    controls = uvcControl.getCameraControls();
}

//--------------------------------------------------------------
void testApp::draw(){
    ofBackground(0);
	vidGrabber.draw(0,0);
    
    ofSetColor(255);
    stringstream s;
    s << "Auto-exposure: " << uvcControl.getAutoExposure() << "\nPress any key to toggle auto-exposure.\n\nResult of GET_STATUS for each feature\non this camera:\n";
        
    
    for(int i = 0; i < controls.size(); i++){
    
        s << controls.at(i).name << ": " << controls.at(i).status << "\n";

    }
    
    
    ofDrawBitmapString(s.str(), 650, 10);

}

void testApp::exit(){
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    uvcControl.setAutoExposure(!uvcControl.getAutoExposure());
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