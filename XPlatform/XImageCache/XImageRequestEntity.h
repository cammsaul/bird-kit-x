//
//  XImageViewRequestEntity.h
//  XPlatform
//
//  Created by Cameron Saul on 11/12/13.
//  Copyright (c) 2013 Cam Saül All rights reserved.
//

@interface XImageRequestEntity : NSObject

/// The actual URL that should be used when fetching from the web.
@property (nonatomic, strong, readonly) NSURL *actualURL;

/// If and existing XImageRequestEntity for the same imageURL already exists, return that (they can be used for
/// multiple imageViews); otherwise, create a new XImageRequestEntity.
+ (XImageRequestEntity *)requestEntityWithImageURL:(NSURL *)imageURL;

/// Completion block will NOT be called on the main thread!!!
- (void)fetchImageFromServerWithCompletion:(void(^)(UIImage *fetchedImage))completion;

@end
