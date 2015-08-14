//
//  UIImage+X.m
//  XPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import "UIImage+X.h"

@implementation UIImage (X)

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    uint8_t *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
	   
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
	
	CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    CGColorSpaceRelease(colorSpace);
	
    UIImage *image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight]; // captureStillImageAsynchronouslyFromConnection always outputs image with orientation to the right
    CGImageRelease(newImage);

	return image;
}

+ (UIImage *)imageFromView:(UIView *)view {
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return outputImage;
}

- (UIImage *)imageScaledToSize:(CGSize)size {
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
	// maintain aspect ratio
	const float resizeFactor = MAX(size.width / self.size.height, size.height / self.size.height);
	CGSize newSize = CGSizeMake(self.size.width * resizeFactor, self.size.height * resizeFactor);
	if (newSize.width < size.width) {
		float factor = size.width / newSize.width;
		newSize = CGSizeMake(newSize.width * factor, newSize.height * factor);
	}
	if (newSize.height < size.height) {
		float factor = size.height / newSize.height;
		newSize = CGSizeMake(newSize.width * factor, newSize.height * factor);
	}
	const int xOffset = (newSize.width - size.width) * -0.5;
	const int yOffset = (newSize.height - size.height) * -0.5;
	
    [self drawInRect:CGRectMake(xOffset, yOffset, newSize.width, newSize.height)];
		
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return properly rotated image
    return image;
}

@end
