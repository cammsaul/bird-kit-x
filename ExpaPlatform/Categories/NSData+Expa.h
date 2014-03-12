//
//  NSData+Expa.h
//  ExpaPlatform
//
//  Created by Cam Saul on 3/12/14.
//  Copyright (c) 2014 Expa, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Expa)

/// Returns a MD5 hash of supplied data.
- (NSString *)MD5Hash;

@end
