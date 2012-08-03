//
//  GF_sharedSingleton.m
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/2/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import "GF_sharedSingleton.h"

@implementation GF_sharedSingleton

    
+ (GF_sharedSingleton *)sharedSingleton
{
    static GF_sharedSingleton *sharedSingleton;
    @synchronized(self)
    {
        if(!sharedSingleton)
        {
            sharedSingleton = [[GF_sharedSingleton alloc] init];
            //Initialize all the values for your class variables here.
            
            //Init the mutable array of connected peers.
            sharedSingleton->dataPeers=[[NSMutableArray alloc] init];
            //Init the mutable array of photos.
            sharedSingleton->photoAlbum=[[NSMutableArray alloc] init];
            //Init the UIImage photoCaptured here.
            sharedSingleton->photoCaptured = [[UIImage alloc] init];
        }
        return sharedSingleton;
    }
}

//Allocates GKSession and
//Connects to other peers in the area that are detected,
//Uses BlueTooth or Wireless, depending on what is available.
-(void)connectToPeers:(id)sender {
    if([sender tag]==11)
    {
        isHost = YES;
    }
    else {
        isHost = NO;
    }
    
    //Set this up as a server
    if (isHost) {
        GKSession *session = [[GKSession alloc] initWithSessionID:@"com.grace.senddata" displayName:@"Server" sessionMode:GKSessionModeServer];
        dataSession = session;
        session.delegate = self;
        session.available = YES;       
        NSLog(@"Setting Server Session Peer:%@",  session.peerID);
        
    } 
    
    //Or set it up as a client
    else {
        GKSession *session = [[GKSession alloc] initWithSessionID:@"com.grace.senddata" displayName:nil sessionMode:GKSessionModeClient];
        dataSession = session;
        dataSession.available = YES;
        session.delegate = self;
        session.available = YES;
        NSLog(@"Setting CLIENT Session Peer:%@", session.peerID);
        [dataSession setDataReceiveHandler:self withContext:nil];
    }
    
    dataSession.available = YES;

}

//GKSession Delegate Methods
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
    dataSession = session;
    
	switch(state){
            //Other Device Found, attempt to connect.
        case GKPeerStateAvailable:
        {
            
            //A device in the area was found. Connect.
            NSLog(@"Client available...");
            [session connectToPeer:peerID withTimeout:0];
            
        }
            break;
            //Connecting
        case GKPeerStateConnecting:
        {
            NSLog(@"Client Connecting...");
        }
            break;
            //Device connected to server.
        case GKPeerStateConnected:
        {
            NSLog(@"Client connected!");
            //Used to acknowledge that we will be sending data
            [session setDataReceiveHandler:self withContext:nil];
            
            //Add the peer to the dataPeers Array
            [dataPeers addObject:peerID];
            
            NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
            break;
            //Device disconnected.
        case GKPeerStateDisconnected:
        {
            NSLog(@"Client Disconnected.");
        }
            break;
            //Device unavailable.
        case GKPeerStateUnavailable:
        {
            NSLog(@"Client is unavailable.");
        }
            break;
    }
    
	
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    NSLog(@"Recieved Connection Request");
    NSLog(@"%@", peerID);
    NSString * peerName = [session displayNameForPeer:peerID];
    NSLog(@"%@", peerName);
    
    //If you want to implement acceptance/rejection of connections, use this template. If not, ignore.
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Request" message:[NSString stringWithFormat:@"The Client %@ is trying to connect.", peerName] delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
     [alert show];
     
     if(selection == @"accept"){
     [session acceptConnectionFromPeer:peerID error:nil];
     }else{
     [session denyConnectionFromPeer:peerID];
     }*/
    
    [session acceptConnectionFromPeer:peerID error:nil];
    
}

- (void) requestCapture:(id)sender{
    NSString *msg = @"capture";
    
    //Send msg to one device.
    //[dataSession sendData:[msg dataUsingEncoding: NSASCIIStringEncoding] toPeers:dataPeers withDataMode:GKSendDataReliable error:nil];
    
    //Tells all the connected clients to take a picture.
    [dataSession sendDataToAllPeers:[msg dataUsingEncoding:NSASCIIStringEncoding] withDataMode:GKSendDataReliable error:nil];
    
    //Takes a picture on the server iOS device (the one you're using, if that's you).
    /*________________________________
     | Takes a photo programmatically. |
     --------------------------------*/
    sleep(1); //For some reason, capturing a still image does not work unless there is a small delay.
    //[self.cam capturePicture]; //Capture still image.
    photoCaptured = currentImage;
    //*********************************************************
    if(photoCaptured)
    {
        NSLog(@"requestCapture: Picture taken is not nil, and it was added to the album array.");
        [photoAlbum addObject:photoCaptured];
    }
    
}

//Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    NSString *whatDidIGet = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    
    //If the msg was to take a picture.
        if([whatDidIGet isEqualToString:@"capture"])
        {
            //Dsiplay the data as a UIAlertView
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Command Received" message:whatDidIGet delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            /*________________________________
             | Takes a photo programmatically. |
             --------------------------------*/
            sleep(1); //For some reason, capturing a still image does not work unless there is a small delay.
            
            //Code to capture a still image.
            
            //*****Todo: Figure out how to take a picture in singleton.
            //[self.cam capturePicture]; //Capture still image.
            photoCaptured = currentImage;
            NSLog(@"Picture taken on request.");
            //Set photoCaptured Equal to the still image
            //*********************************************************


            [photoAlbum addObject:photoCaptured];
        }
        
    else {

        NSString *receivedImageMsg = @"You received a photo from the network.";
        //If data was an image, receive it and display received message. Add it to the album.
        UIImage *receivedImage = [UIImage imageWithData:data];
        [photoAlbum addObject:receivedImage];

        //self.imageView.image = receivedImage;
        //Background color should change if image is set to self.imageView.image
        //self.view.backgroundColor = [UIColor whiteColor];
//        UIImageView *iv = [[UIImageView alloc] initWithImage:[self.photoAlbum objectAtIndex:0]];
//        iv.animationImages = self.photoAlbum;
//        iv.animationDuration = 0.1;
//        iv.animationRepeatCount = 0;
//        [iv startAnimating];
//        [self.view addSubview:iv];
        
        
        
        
        //[self.view addSubview:iv];
        
        
        //self.imageView.image = receivedImage;
        
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Received" message:receivedImageMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
}

-(void)setCurrentPhoto:(UIImage *)image {
    photoCaptured = image;
}

-(void)setCurrentImageFromCam:(UIImage*)image {
    currentImage = image;
}

-(NSMutableArray*)getAlbum {
    return photoAlbum;
}

-(void) addPhoto:(UIImage *)image {
    [photoAlbum addObject:image];
}



@end
