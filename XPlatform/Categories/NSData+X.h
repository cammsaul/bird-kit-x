//
//  NSData+X.h
//  XPlatform
//
//  Created by Cam Saül on 3/12/14.
//  Copyright (c) 2014 Cam Saül. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (X)

/// Returns a MD5 hash of supplied data.
- (NSString *)MD5Hash;

@end
