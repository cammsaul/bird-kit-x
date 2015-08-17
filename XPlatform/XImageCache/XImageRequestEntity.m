//
//  XImageViewRequestEntity.m
//  XPlatform
//
//  Created by Cameron Saul on 11/12/13.
//  Copyright (c) 2013 Cam Saül All rights reserved.
//

#import <objc/runtime.h>

#import "XGCDUtilities.h"
#import "XImageRequestEntity.h"


/// Wrapper for XImageRequestEntity, so the XImageRequestEntity is not retained by anthing except imageView(s) that own it
@interface XImageRequestEntityWeakRef : NSObject
@property (nonatomic, weak) XImageRequestEntity *imageRequestEntity;
@end
@implementation XImageRequestEntityWeakRef
@end

@interface XImageRequestEntity ()
@property (nonatomic, strong, readwrite) NSURL *actualURL;
@property (nonatomic, readwrite) UIImage *fetchedImage;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;
@end

@implementation XImageRequestEntity


#pragma mark - Lifecycle

- (id)init {
	if (self = [super init]) {
		self.operationQueue = [[NSOperationQueue alloc] init];
		self.operationQueue.maxConcurrentOperationCount = 1;
	}
	return self;
}

- (void)dealloc {
	[_operationQueue cancelAllOperations];
	_operationQueue = nil;
}

+ (XImageRequestEntity *)requestEntityWithImageURL:(NSURL *)imageURL {
	if (!imageURL) return nil;
	
	/// static dictionary of existing request entities and serial dispatch queue for thread-safe access
	/// key imageURL -> XImageRequestEntityWeakRef
	static NSMutableDictionary *existingEntities;
	static dispatch_queue_t existingEntitiesDispatchQueue;
	
	// create static objects if needed
	@synchronized(XImageRequestEntity.class) {
		if (!existingEntities) {
			existingEntities = [NSMutableDictionary dictionary];
			existingEntitiesDispatchQueue = dispatch_queue_create("xplatform.existingEntitiesDispatchQueue", DISPATCH_QUEUE_SERIAL);
		}
	}

	/// Do Synchronous (thread-safe) check for existing request, return if found
	__block __weak XImageRequestEntity *existingEntity;
	dispatch_sync(existingEntitiesDispatchQueue, ^{
		XImageRequestEntityWeakRef *weakRef = existingEntities[imageURL];
		existingEntity = weakRef.imageRequestEntity;
	});
	
	if (existingEntity) {
		return existingEntity;
	} else {
		XImageRequestEntity *requestEntity = [[XImageRequestEntity alloc] init];
		requestEntity.actualURL = imageURL;
		XImageRequestEntityWeakRef *weakRef = [[XImageRequestEntityWeakRef alloc] init];
		weakRef.imageRequestEntity = requestEntity;
		dispatch_barrier_async(existingEntitiesDispatchQueue, ^{
			existingEntities[imageURL] = weakRef;
		});
		return requestEntity;
	}
}


#pragma mark - Etc

- (NSString *)description {
	return [NSString stringWithFormat:@"<XImageRequestEntity>: %@", self.actualURL];
}

- (BOOL)isEqual:(XImageRequestEntity *)object {
	return object.class == self.class && [self.actualURL isEqual:object.actualURL];
}

- (NSUInteger)hash {
	return [_actualURL hash];
}


#pragma mark - Fetching

- (void)fetchImageFromServerWithCompletion:(void(^)(UIImage *))completionBlock {
	with_weak_ref(self, ^(__weak XImageRequestEntity *wSelf) { // don't retain self, we may be removed in the (very) near future
		if (wSelf.fetchedImage) {
			completionBlock(wSelf.fetchedImage);
			return;
		}
		
		NSURLRequest *request = [NSURLRequest requestWithURL:wSelf.actualURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
		
		[NSURLConnection sendAsynchronousRequest:request queue:wSelf.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			dispatch_async_low_priority(^{
				if (connectionError) {
					NSLog(@"Error fetching image from web: %@", connectionError);
					completionBlock(nil);
					return;
				}
				wSelf.fetchedImage = [[UIImage alloc] initWithData:data];
				if (!wSelf.fetchedImage) {
					NSLog(@"Error: could not init image with data: %@", response);
					completionBlock(nil);
					return;
				}
				completionBlock(wSelf.fetchedImage);
			});
		}];
	});
}

@end
