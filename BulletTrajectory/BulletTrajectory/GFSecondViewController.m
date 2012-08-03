//
//  GFSecondViewController.m
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/2/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import "GFSecondViewController.h"

@interface GFSecondViewController ()

@end

@implementation GFSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)connect:(id)sender {
    GF_sharedSingleton *shared = [GF_sharedSingleton sharedSingleton];
    [shared connectToPeers:(id)sender];
}

@end
