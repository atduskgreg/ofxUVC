#pragma once

#include "ofMain.h"
#include "ofxUVC.h"
//#include "ofxQTKitVideoGrabber.h"
#include "ofxYAML.h"

/*
struct ofxUVCCameraSetting {
    int vendorId, productId, interfaceNum;
    string name;
};

void operator >> (const YAML::Node& node, ofxUVCCameraSetting& cam) {
    node["vendorId"] >> cam.vendorId;
    node["productId"] >> cam.productId;
    node["interfaceNum"] >> cam.interfaceNum;
    node["name"] >> cam.name;
}*/

class testApp : public ofBaseApp{
	public:
		void setup();
		void update();
		void draw();
		
		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y);
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
    
    void exit();
    
    ofQTKitGrabber	vidGrabber;

    ofTexture tex;

    ofxUVC uvcControl;
    ofxYAML yaml;
    string cameraName;
    
    int camWidth, camHeight;
    
    float focus;
    
    vector<ofxUVCControl> controls;
};
