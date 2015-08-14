//
//  UIImage+X.h
//  XPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>

@interface UIImage (X)

/// Creates a new UIImage from a CoreMedia sample buffer.
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/// Renders the UIView using the device's current scaling as a UIImage.
+ (UIImage *)imageFromView:(UIView *)view;

/// Render a new version of the image scaled to fit a certain size.
- (UIImage *)imageScaledToSize:(CGSize)size;

@end
