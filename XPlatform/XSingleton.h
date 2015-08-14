//
//  XSingleton.h
//  XPlatform
//
//  Created by Cam Saül on 3/2/14.
//  Copyright (c) 2014 Cam Saül. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Thread-safe implementation of the singleton pattern that takes ensuring object is only allocated once, etc. Singleton objects should derive from this.
/// Singletons should override the init method to do initialization as needed.
@interface XSingleton : NSObject

/// Return the shared instance of the singleton.
+ (instancetype)sharedInstance;

@end
