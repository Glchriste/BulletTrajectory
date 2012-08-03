//
//  GFFirstViewController.m
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/2/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import "GF_sharedSingleton.h"
#import "GFFirstViewController.h"
#import "GFImageUtils.h"
#import "GF_ARView.h"
#import <QuartzCore/QuartzCore.h>

@interface GFFirstViewController ()

-(void) startCameraCapture;
-(void) stopCameraCapture;

@end

@implementation GFFirstViewController

@synthesize arView;
@synthesize previewView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arView.layer.borderColor = [UIColor greenColor].CGColor;
    arView.layer.borderWidth = 3.0f;
    //Start the camera.
    [self startCameraCapture];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
//}

#pragma mark -
#pragma mark Camera Capture Control

-(void) startCameraCapture {
    //Start capturing frames.
    //Create the AVCaptureSession.
    session = [[AVCaptureSession alloc] init];
    //Create a preview layer to display the output from the camera.
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.frame = previewView.frame;
    [previewView.layer addSublayer:previewLayer];
    
    //Get the default camera device.
    AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //Create a AVCaptureInput with the camera device.
    NSError *error=nil;
    AVCaptureInput *cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    if(cameraInput == nil) {
        NSLog(@"Error to create camera capture:%@",error);
    }
    //Set the output.
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    //Create a queue to run the capture on.
    dispatch_queue_t captureQueue = dispatch_queue_create("captureQueue", NULL);
    //Setup our delegate.
    [videoOutput setSampleBufferDelegate:self queue:captureQueue];
    //Configure the pixel format.
    videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey, nil];
    //And the size of the frames that we want.
    [session setSessionPreset:AVCaptureSessionPresetMedium];
    //Add the input and output.
    [session addInput:cameraInput];
    [session addOutput:videoOutput];
    //Start the session.
    [session startRunning];
}

-(void) stopCameraCapture {
    [session stopRunning];
    session = nil;
}

#pragma mark -
#pragma mark Image processing

-(void) processImage {
	if(imageToProcess) {
		// move and scale the overlay view so it is on top of the camera image 
		// (the camera image will be aspect scaled to fit in the preview view)
		float scale=MIN(previewView.frame.size.width/imageToProcess->width, 
						previewView.frame.size.height/imageToProcess->height);
		arView.frame=CGRectMake((previewView.frame.size.width-imageToProcess->width*scale)/2,
                                (previewView.frame.size.height-imageToProcess->height*scale)/2,
                                imageToProcess->width, 
                                imageToProcess->height);
		arView.transform=CGAffineTransformMakeScale(scale, scale);
		
		
		// detect vertical lines
		CGMutablePathRef pathRef=CGPathCreateMutable();
		int lastX=-1000, lastY=-1000;
		for(int y=0; y<imageToProcess->height-1; y++) {
			for(int x=0; x<imageToProcess->width-1; x++) {
				int edge=(abs(imageToProcess->pixels[y][x]-imageToProcess->pixels[y][x+1])+
						  abs(imageToProcess->pixels[y][x]-imageToProcess->pixels[y+1][x])+
						  abs(imageToProcess->pixels[y][x]-imageToProcess->pixels[y+1][x+1]))/3;
				if(edge>10) {
					int dist=(x-lastX)*(x-lastX)+(y-lastY)*(y-lastY);
					if(dist>50) {
						CGPathMoveToPoint(pathRef, NULL, x, y);
						lastX=x;
						lastY=y;
					} else if(dist>10) {
						CGPathAddLineToPoint(pathRef, NULL, x, y);
						lastX=x;
						lastY=y;
					}
				}
			}
		}	
		
		// draw the path we've created in our ARView
		arView.pathToDraw=pathRef;
		
		// done with the image
		destroyImage(imageToProcess);
		imageToProcess=NULL;
	}
}
//Delegation method.

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection { 
    
    // this is the image buffer  
    CVImageBufferRef cvimgRef = CMSampleBufferGetImageBuffer(sampleBuffer);  
    // Lock the image buffer  
    CVPixelBufferLockBaseAddress(cvimgRef,0);  
    // access the data  
    int width=CVPixelBufferGetWidth(cvimgRef);  
    int height=CVPixelBufferGetHeight(cvimgRef);  
    // get the raw image bytes  
    uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);  
    size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef); 
    
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();  
    CGContextRef context=CGBitmapContextCreate(buf, width, height, 8, bprow, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipFirst);  
    CGImageRef image=CGBitmapContextCreateImage(context);  
    CGContextRelease(context);  
    CGColorSpaceRelease(colorSpace);  
    UIImage *resultUIImage=[UIImage imageWithCGImage:image];  
    CGImageRelease(image);
    currentImage = resultUIImage;
    
    GF_sharedSingleton *shared = [GF_sharedSingleton sharedSingleton];
    [shared setCurrentImageFromCam:resultUIImage];

    
    
}

-(IBAction)capturePhoto:(id)sender {
    GF_sharedSingleton *shared = [GF_sharedSingleton sharedSingleton];
    [shared setCurrentPhoto:currentImage];
    [shared addPhoto:currentImage];
    [shared requestCapture:(id)sender];
    NSLog(@"Picture taken.");
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[self stopCameraCapture];
	self.previewView=nil;
}


- (void)dealloc {
	[self stopCameraCapture];
	self.previewView = nil;
	self.arView = nil;
}


@end
