//
//  GFThirdViewController.m
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/3/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import "GFThirdViewController.h"
#import "GF_sharedSingleton.h"

@interface GFThirdViewController ()

@end

@implementation GFThirdViewController

@synthesize imageView;
@synthesize imageView2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        GF_sharedSingleton *shared = [GF_sharedSingleton sharedSingleton];
        if([shared getAlbum])
            albumImages = [shared getAlbum];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GF_sharedSingleton *shared = [GF_sharedSingleton sharedSingleton];
    albumImages = [shared getAlbum];
    if([shared getAlbum])
    {
        if([albumImages lastObject])
        {
            imageView.image = [albumImages lastObject];
        }
        
        if(albumImages.count > 1)
imageView2.image = [albumImages objectAtIndex:albumImages.count-2];
    }
}

- (void)viewDidUnload
{
    [self setImageView2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
