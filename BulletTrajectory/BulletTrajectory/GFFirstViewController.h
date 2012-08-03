//
//  GFFirstViewController.h
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/2/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GFImageUtils.h"

@class GF_ARView;

@interface GFFirstViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureSession *session;
    UIView *previewView;
    GF_ARView *arView;
    Image *imageToProcess;
    UIImage *currentImage;
    

}

@property (nonatomic, retain) IBOutlet UIView *arView;
@property (nonatomic, retain) IBOutlet UIView *previewView;

@end
