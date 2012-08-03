//
//  GFFourthViewController.m
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/3/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import "GFFourthViewController.h"

@interface GFFourthViewController ()

@end

@implementation GFFourthViewController
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        GF_sharedSingleton *shared = [GF_sharedSingleton sharedSingleton];
        
        imageView.animationImages = [shared getAlbum];
        imageView.animationRepeatCount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GF_sharedSingleton *shared = [GF_sharedSingleton sharedSingleton];
    imageView.animationImages = [shared getAlbum];
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];
}

- (void)viewDidUnload
{
    [imageView stopAnimating];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
