//
//  XImageCache.h
//  XPlatform
//
//  Created by Cameron Saul on 11/11/13.
//  Copyright (c) 2013 Cam Saül All rights reserved.
//

#import "XSingleton.h"

/// Intermediate layer between FastImageCache and actual app usage
@interface XImageCache : XSingleton

/// Loads image with URL to a weakly referenced imageView. Automatically adds/removes a loading spinner if needed.
/// Takes care to eliminate unneccesary requests.
/// Does not need to be ran on the main thread.
+ (void)loadImageWithURL:(NSURL *)imageURL forImageView:(UIImageView __weak *)imageView completion:(void(^)(NSURL *imageURL, UIImage *image))completion;

/// Helper method to call loadImageWithURL:withImageFormat:forImageView:completion after converting the std::string to an NSURL
+ (void)loadImageWithURLString:(NSString *)actualURLString forImageView:(UIImageView __weak *)imageView completion:(void(^)(NSURL *imageURL, UIImage *image))completion;

@end
