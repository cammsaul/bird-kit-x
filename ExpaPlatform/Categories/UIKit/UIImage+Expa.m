//
//  UIImage+Expa.m
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "UIImage+Expa.h"

@implementation UIImage (Expa)

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

@end
