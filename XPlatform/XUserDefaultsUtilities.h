//
//  XUserDefaultsUtilities.h
//  XPlatform
//
//  Created by Cameron T Saul on 8/19/15.
//  Copyright (c) 2015 Cam Saül. All rights reserved.
//

#define USER_DEFAULTS_PROPERTY(TYPE, GETTER_METHOD, SETTER_METHOD, GETTER, SETTER)  \
    \
    static NSString * const GETTER##Key = @"" #GETTER; \
    \
    - (TYPE)GETTER { \
        return [[NSUserDefaults standardUserDefaults] GETTER_METHOD:GETTER##Key]; \
    } \
    \
    - (void)SETTER:(TYPE)value { \
        [[NSUserDefaults standardUserDefaults] SETTER_METHOD:value forKey:GETTER##Key]; \
        [[NSUserDefaults standardUserDefaults] synchronize]; \
    }

#define USER_DEFAULTS_STRING_PROPERTY(GETTER, SETTER) \
    USER_DEFAULTS_PROPERTY(NSString *, stringForKey, setObject, GETTER, SETTER)

#define USER_DEFAULTS_INTEGER_PROPERTY(GETTER, SETTER) \
    USER_DEFAULTS_PROPERTY(NSInteger, integerForKey, setInteger, GETTER, SETTER)

#define USER_DEFAULTS_UNSIGNED_INTEGER_PROPERTY(GETTER, SETTER) \
    USER_DEFAULTS_PROPERTY(NSUInteger, integerForKey, setInteger, GETTER, SETTER)
