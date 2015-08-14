//  -*-ObjC-*-
//  NSDictionary+X.h
//  Cam Saül
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (X)

/// Recursively merges self with another dictionary. If the value for a given key in both dictionaries is itself a dictionary,
/// will recursively merge those dictionaries. If a value is present in both dictionaries but is not itself a dictionary,
/// the value for self will be preferred.
- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)dictionary;


/***** The following methods are intended primarily to help with using XNavigationService *****/

/// Returns a new dictionary by copying the current dictionary and setting value for key.
/// You may use this method to remove a value from a dictionary, by passing nil as the value parameter.
- (NSDictionary *)dictionaryBySettingValue:(NSObject *)value forKey:(NSString const * const)key;

/// Returns YES if the dictionary contains a NSNumber associated with key.
- (BOOL)containsNumber:(NSString *)key;

/// Returns an integer value for the NSNumber associated with key.
- (NSInteger)valueForInteger:(NSString *)key;

/// Returns a float value for the NSNumber associated with key.
- (float)valueForFloat:(NSString *)key;

/// Returns a double value for the NSNumber associated with key.
- (double)valueForDouble:(NSString *)key;

/// Returns a boolean value for the NSNumber associated with key.
- (BOOL)valueForBool:(NSString *)key;

/// Returns JSON string representation of dictionary, pretty printed, or nil if serialization produces an error
/// @seealso JSONStringWithError:
- (NSString *)JSONString;

/// Returns JSON string representation of dictionary, pretty printed, with error out param
/// @seealso JSONString
- (NSString *)JSONStringWithError:(__autoreleasing NSError **)error;

@end
