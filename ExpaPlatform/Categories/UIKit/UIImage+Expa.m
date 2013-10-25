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
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVPixelBufferLockBaseAddress(imageBuffer, 0); // Lock the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer); // Get the number of bytes per row for the pixel buffer
	
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); // Get the number of bytes per row for the pixel buffer
    
    size_t width = CVPixelBufferGetWidth(imageBuffer); // Get the pixel buffer width and height
    size_t height = CVPixelBufferGetHeight(imageBuffer);
	   
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); // Create a device-dependent RGB color space
	
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
												 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context); // Create a Quartz image from the pixel data in the bitmap graphics context
    CVPixelBufferUnlockBaseAddress(imageBuffer,0); // Unlock the pixel buffer
	
    CGContextRelease(context); // Free up the context and color space
    CGColorSpaceRelease(colorSpace);
	
    UIImage *image = [UIImage imageWithCGImage:quartzImage]; // Create an image object from the Quartz image
    CGImageRelease(quartzImage); // Release the Quartz image

	return image;
}

@end
