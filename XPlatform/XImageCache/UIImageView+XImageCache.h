//
//  UIImageView+XImageCache.h
//  XPlatform
//
//  Created by Cameron Saul on 11/12/13.
//  Copyright (c) 2013 Cam Saül All rights reserved.
//

@class XImageRequestEntity;

@interface UIImageView (XImageCache)

/// An object that represents information needed to fetch images from the network.
/// Multiple imageViews can shared the same XImageRequestEntity; the object itself manages an NSOperationQueue
/// of NSURLRequests so the same image is never fetched twice.
@property (nonatomic, strong, readwrite) XImageRequestEntity *requestEntity;

/// Cancels any existing image fetch requests
- (void)cancelExistingFetchRequests;

@end
