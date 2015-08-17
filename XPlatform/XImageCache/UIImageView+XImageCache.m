//
//  UIImageView+XImageCache.m
//  XPlatform
//
//  Created by Cameron Saul on 11/12/13.
//  Copyright (c) 2013 Cam Saül All rights reserved.
//

#import <objc/runtime.h>

#import "UIImageView+XImageCache.h"
#import "XImageRequestEntity.h"

static const char RequestEntityKey;

@implementation UIImageView (XImageCache)

#pragma mark - Category Methods

- (XImageRequestEntity *)requestEntity	{ return objc_getAssociatedObject(self, &RequestEntityKey); }

- (void)setRequestEntity:(XImageRequestEntity *)requestEntity {
	XImageRequestEntity *existing = self.requestEntity;
	if ([existing isEqual:requestEntity]) return;
	objc_setAssociatedObject(self, &RequestEntityKey, requestEntity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cancelExistingFetchRequests {
	self.requestEntity = nil;
}

@end
