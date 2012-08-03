//
//  GFImageUtils.h
//  BulletTrajectory
//
//  Created by Grace Christenbery on 8/2/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
	uint8_t *rawImage;
	uint8_t **pixels;
	int width;
	int height;
} Image;

Image *createImage(uint8_t *bytes, size_t bprow, int srcWidth, int srcHeight);
CGImageRef toCGImage(Image *srcImage);
void destroyImage(Image *image);