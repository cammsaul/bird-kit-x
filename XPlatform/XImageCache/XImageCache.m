//
//  XImageCache.m
//  XPlatform
//
//  Created by Cameron Saul on 11/11/13.
//  Copyright (c) 2013 Cam Saül All rights reserved.
//

#import "NSString+X.h"
#import "XGCDUtilities.h"
#import "XImageCache.h"
#import "XImageRequestEntity.h"
#import "UIImage+X.h"
#import "UIImageView+XImageCache.h"
#import "UIView+X.h"

/// Number of photos to keep in memory (in LRU) before removing some
static const unsigned kMaxInMemoryCacheCount = 100;

/// Quality for JPEG-compressed images on disk
static const CGFloat kJPEGDiskImageQuality = 0.8f;

/// Number of photos to keep on disk) before removing some
static const unsigned kMaxOnDiskCount = 1000;

/// Do some local (in-memory) caching with a simple LRU, represented by a mutable dictionary of imageURL -> image and an ordered set to keep track of images that were used etc
@interface XImageCache ()
/// So we can do dispatch_barrier_async for writes
@property (nonatomic) dispatch_queue_t LRUDispatchQueue;
@property (nonatomic, strong) NSMutableOrderedSet *LRUOrderedSet;
@property (nonatomic, strong) NSMutableDictionary *LRUDictionary;
@property (nonatomic, strong) NSString *cachePath;

+ (XImageCache *)sharedInstance;
@end

@implementation XImageCache

+ (XImageCache *)sharedInstance {
	return [super sharedInstance];
}

- (id)init {
	if (self = [super init]) {
		self.LRUDispatchQueue = dispatch_queue_create("xplatform.imageCacheLRUDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
		self.LRUOrderedSet = [NSMutableOrderedSet orderedSet];
		self.LRUDictionary = [NSMutableDictionary dictionary];
		self.cachePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
		
		// check number of files in disk cache
		dispatch_async_background_priority(^{
			NSError *fileCountError;
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSArray *fileContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cachePath error:&fileCountError];
			if (fileCountError) {
				return;
			} else {
				NSLog(@"File count: %lu", fileContents.count);
				
				if (fileContents.count > kMaxOnDiskCount) {
					// get absolute path for all files, and creation date.
					NSMutableArray *files = [NSMutableArray array];
					for (NSString *fileRelativePath in fileContents) {
						NSString *filePath = [self.cachePath stringByAppendingPathComponent:fileRelativePath];
						
						NSError *fileAttributeError;
						NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&fileAttributeError];
						if (fileAttributeError) {
							continue;
						} else {
							NSDate *modificationDate = fileAttributes[NSFileModificationDate];
							[files addObject:@[filePath, modificationDate]];
						}
					}
					
					// now sort by modification date
					[files sortUsingComparator:^NSComparisonResult(NSArray *p1, NSArray *p2) {
						NSDate *d1 = p1[1], *d2 = p2[1];
						return [d2 compare:d1];
					}];
					
					while (files.count > kMaxOnDiskCount) {
						NSArray *file = files.lastObject;
						[files removeLastObject];
						NSString *filePath = file[0];
						[fileManager removeItemAtPath:filePath error:nil];
					}
					NSLog(@"File count: %lu", files.count);
				}
			}
		});
	}
	return self;
}


#pragma mark - In-Memory (LRU) Cache

+ (NSString *)inMemoryKeyForImageURL:(NSURL *)imageURL size:(CGSize)size {
	return [imageURL.description stringByAppendingFormat:@"_%d_%d", (int)size.width, (int)size.height];
}

+ (UIImage *)loadImageFromInMemoryCache:(NSURL *)imageURL size:(CGSize)size {
	if (!imageURL) return nil;
	NSString *imageKey = [self inMemoryKeyForImageURL:imageURL size:size];
	
	__block UIImage *image = nil;
	dispatch_sync([self sharedInstance].LRUDispatchQueue, ^{
		image = [self sharedInstance].LRUDictionary[imageKey];
	});
	
	// move image to front of LRU
	dispatch_barrier_async([self sharedInstance].LRUDispatchQueue, ^{
		[[self sharedInstance].LRUOrderedSet removeObject:imageKey];
		[[self sharedInstance].LRUOrderedSet insertObject:imageKey atIndex:0];
	});
	return image;
}

+ (void)saveImage:(UIImage *)image withURLToInMemoryCache:(NSURL *)imageURL size:(CGSize)size {
	if (!image || !imageURL) return;
	dispatch_barrier_async([self sharedInstance].LRUDispatchQueue, ^{
		NSString *imageKey = [self inMemoryKeyForImageURL:imageURL size:size];
		[self sharedInstance].LRUDictionary[imageKey] = image;
		
		// move to front of ordered set
		[[self sharedInstance].LRUOrderedSet removeObject:imageKey];
		[[self sharedInstance].LRUOrderedSet insertObject:imageKey atIndex:0];
		
		// remove last item if LRU is over capacity now
		while ([self sharedInstance].LRUOrderedSet.count > kMaxInMemoryCacheCount) {
			NSURL *lastURL = [self sharedInstance].LRUOrderedSet.lastObject;
			[[self sharedInstance].LRUOrderedSet removeObject:lastURL];
			[[self sharedInstance].LRUDictionary removeObjectForKey:lastURL];
		}
	});
}

#pragma mark - Disk Cache

+ (NSString *)cachePathForImageURL:(NSURL *)imageURL size:(CGSize)size {
	return [[[self sharedInstance].cachePath stringByAppendingPathComponent:[imageURL.description urlEncodeUsingEncoding:NSUTF8StringEncoding]] stringByAppendingFormat:@"_%d_%d", (int)size.width, (int)size.height];
}

+ (UIImage *)loadImageFromDiskCache:(NSURL *)imageURL size:(CGSize)size {
	if (!imageURL) return nil;
	
	NSString *path = [self cachePathForImageURL:imageURL size:size];
	UIImage *image = [UIImage imageWithContentsOfFile:[self cachePathForImageURL:imageURL size:size]];
	
	// touch the image on disk
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *fileAttributeError;
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&fileAttributeError];
	if (!fileAttributeError) {
		NSMutableDictionary *mFileAttributes = fileAttributes.mutableCopy;
		mFileAttributes[NSFileModificationDate] = [NSDate date];
		[fileManager setAttributes:mFileAttributes ofItemAtPath:path error:nil];
	}
	
	return image;
}

+ (void)saveImage:(UIImage *)image withURLToDiskCache:(NSURL *)url size:(CGSize)size {
	if (!image) return;
	dispatch_async_background_priority(^{
		NSData *imageData = UIImageJPEGRepresentation(image, kJPEGDiskImageQuality);
		[imageData writeToFile:[self cachePathForImageURL:url size:size] atomically:NO];
	});
}

#pragma mark - Loading

+ (void)loadImageWithURL:(NSURL *)actualURL forImageView:(UIImageView __weak *)wImageView completion:(void(^)(NSURL *imageURL, UIImage *image))completion {
	CGSize desiredSize = { wImageView.size.width, wImageView.size.height };
	
	XImageRequestEntity *oldRequestEntity = wImageView.requestEntity;
	XImageRequestEntity *requestEntity = [oldRequestEntity.actualURL isEqual:actualURL] ? oldRequestEntity : [XImageRequestEntity requestEntityWithImageURL:actualURL];
	wImageView.requestEntity = requestEntity; // deallocing the old request entity (if it was different) will cancel the NSURLConnection
	
	// always run this part on main thread for scrolling speed
	if (![NSThread isMainThread]) {
		dispatch_async_main(^{
			[self loadImageWithURL:actualURL forImageView:wImageView completion:completion];
			return;
		});
	}
	
	if (!wImageView) return;
	
	// If we have a nil or empty image URL then clear image view and return
	if (!actualURL.description.length) {
		wImageView.image = nil;
		wImageView.showsLoadingSpinner = NO;
		wImageView.requestEntity = nil;
		return;
	}
		
	// Check and see if image is present in memory
	UIImage *inMemoryImage = [self loadImageFromInMemoryCache:actualURL size:desiredSize];
	if (inMemoryImage) {
		wImageView.showsLoadingSpinner = NO;
		wImageView.image = inMemoryImage;
		if (completion) completion(actualURL, inMemoryImage);
		return;
	}
	// Need to fetch the image. Remove existing request entity, fetch new one async
	wImageView.image = nil;
	wImageView.showsLoadingSpinner = YES;
	
	/// run this part in BG. Creating new objects, etc could affect scroll speed
	dispatch_async_default_priority(^{
		// Check and see if image is present on disk. Not free so do asyc
		UIImage *diskImage = [self loadImageFromDiskCache:actualURL size:desiredSize];
		if (diskImage) {
			dispatch_async_main(^{
				if (![requestEntity isEqual:wImageView.requestEntity]) return;
				wImageView.showsLoadingSpinner = NO;
				wImageView.image = diskImage;
				if (completion) completion(actualURL, diskImage);
			});
			[self saveImage:diskImage withURLToInMemoryCache:actualURL size:desiredSize];
			return;
		}
		
		// ok, check and see if image is present in its original size
		diskImage = [self loadImageFromDiskCache:actualURL size:CGSizeZero];
		if (diskImage) {
			// render the image size we want
			UIImage *resizedImage = [diskImage imageScaledToSize:desiredSize];
			dispatch_async_main(^{
				if (![requestEntity isEqual:wImageView.requestEntity]) return;
				wImageView.showsLoadingSpinner = NO;
				wImageView.image = resizedImage;
				if (completion) completion(actualURL, resizedImage);
			});
			[self saveImage:resizedImage withURLToDiskCache:actualURL size:desiredSize];
			[self saveImage:resizedImage withURLToInMemoryCache:actualURL size:desiredSize];
			return;
		}
		
		if (!requestEntity) return; // for some reason we couldn't create the request entity, wtf

		// If the ImageView already has a request entity for the same image, just re-send the fetchImageFromServerWithCompletion: message.
		[requestEntity fetchImageFromServerWithCompletion:^(UIImage *fetchedImage) {
			// render the image size we want
			UIImage *resizedImage = [fetchedImage imageScaledToSize:desiredSize];
			
			dispatch_async_main(^{
				/// If the requested url changed in the meantime then don't set the new image
				if (![requestEntity isEqual:wImageView.requestEntity]) return;
				if (!wImageView) return;
				
				wImageView.image = resizedImage;
				wImageView.showsLoadingSpinner = NO;
				if (resizedImage && completion) completion(actualURL, resizedImage);
			});
						
			// save original to disk only
			[self saveImage:fetchedImage withURLToDiskCache:actualURL size:CGSizeZero];
			
			// save resized image to memory + disk
			[self saveImage:resizedImage withURLToInMemoryCache:actualURL size:desiredSize];
			[self saveImage:resizedImage withURLToDiskCache:actualURL size:desiredSize];
		}];
	});
}

+ (void)loadImageWithURLString:(NSString *)actualURLString forImageView:(UIImageView __weak *)imageView completion:(void(^)(NSURL *imageURL, UIImage *image))completion {
	[self loadImageWithURL:[NSURL URLWithString:actualURLString] forImageView:imageView completion:completion];
}

@end
