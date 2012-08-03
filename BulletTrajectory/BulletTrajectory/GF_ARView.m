//
//  GF_ARView.m
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/2/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import "GF_ARView.h"

@implementation GF_ARView

@dynamic pathToDraw;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Do the drawing here.
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextAddPath(context, pathToDraw);
    CGContextStrokePath(context);
}

- (void) setPathToDraw:(CGMutablePathRef) newPath {
    if(pathToDraw != NULL) CGPathRelease(pathToDraw);
    pathToDraw = newPath;
    [self setNeedsDisplay];
}


@end
