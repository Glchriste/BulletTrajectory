//
//  GF_sharedSingleton.h
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/2/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GF_sharedSingleton : NSObject<GKSessionDelegate, GKPeerPickerControllerDelegate> {
    GKSession *dataSession;
    NSMutableArray *dataPeers;
    BOOL isHost;
    
    
    UIImage* photoCaptured;
    UIImage* currentImage;
    NSMutableArray *photoAlbum;
    
    
}

+ (GF_sharedSingleton *)sharedSingleton;
- (void) connectToPeers:(id)sender;
- (void) requestCapture:(id)sender;
- (void) setCurrentPhoto:(UIImage*)image;
- (void) setCurrentImageFromCam:(UIImage*)image;
- (NSMutableArray*) getAlbum;
-(void) addPhoto:(UIImage*)image;

@end
