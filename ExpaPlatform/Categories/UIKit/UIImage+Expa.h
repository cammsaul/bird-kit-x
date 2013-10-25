//
//  UIImage+Expa.h
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

@import CoreMedia;

@interface UIImage (Expa)

/// Creates a new UIImage from a CoreMedia sample buffer.
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
