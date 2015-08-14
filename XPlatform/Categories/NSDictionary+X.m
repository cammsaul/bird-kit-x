//
//  NSDictionary+X.m
//  Cam Saül
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import "NSDictionary+X.h"
#import "XLogging.h"

@implementation NSDictionary (X)

- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *result = [self mutableCopy];
	
	[dictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
		result[key] = (!self[key] || ![obj isKindOfClass:[NSDictionary class]]) ? obj : [self[key] dictionaryByMergingWithDictionary:(NSDictionary *)obj];
	}];
	
	return result;
}

- (NSDictionary *)dictionaryBySettingValue:(NSObject *)value forKey:(NSString *)key {
	NSMutableDictionary *newDict = [self mutableCopy];
	[newDict setValue:value forKey:key];
	return newDict;
}

- (BOOL)containsNumber:(NSString *)key {
	NSNumber *number = [self objectForKey:key];
	return number && [number isKindOfClass:[NSNumber class]];
}

- (NSInteger)valueForInteger:(NSString *)key {
	return [self[key] integerValue];
}

- (float)valueForFloat:(NSString *)key {
	return [self[key] floatValue];
}

- (double)valueForDouble:(NSString *)key {
	return [self[key] doubleValue];
}

- (BOOL)valueForBool:(NSString *)key {
	return [self[key] boolValue];
}

- (NSString *)JSONString {
	NSError *error = nil;
	NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
	if (error) {
		XLog(self, LogFlagError, @"Error converting NSDictionary to JSON: %@", error.localizedDescription);
	}
	return error ? nil : string;
}

- (NSString *)JSONStringWithError:(__autoreleasing NSError **)error {
	return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:error] encoding:NSUTF8StringEncoding];
}

@end
