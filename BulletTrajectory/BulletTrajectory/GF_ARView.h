//
//  GF_ARView.h
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/2/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFImageUtils.h"

@interface GF_ARView : UIView {
    CGMutablePathRef pathToDraw;
}

@property (nonatomic, assign) CGMutablePathRef pathToDraw;

@end
