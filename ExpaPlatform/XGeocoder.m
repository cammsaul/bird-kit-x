//
//  XGeocoder.m
//  Expa
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import <AddressBook/AddressBook.h>

#import "XGeocoder.h"
#import "XLogging.h"
#import "NSMutableArray+Expa.h"
#import "XLocationUtilities.h"

#pragma mark - XGeocoderResult

@interface XGeocoderResult ()
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *streetAddress;
@property (nonatomic, strong, readwrite) NSString *city;
@property (nonatomic, strong, readwrite) NSString *state;
@property (nonatomic, strong, readwrite) NSString *country;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@end

@implementation XGeocoderResult
- (BOOL)isEqual:(XGeocoderResult *)another {
	if ([another class] != [self class]) return NO;
	return (CLLocationCoordinatesEqual(self.coordinate, another.coordinate)); // consider them to be same geocoding result if they have same coordinates
}
- (NSUInteger)hash {
	return (int)(self.coordinate.latitude * 7.0f) + (int)(self.coordinate.longitude * 3.0f);
}
- (NSString *)description {
	return [NSString stringWithFormat:@"<XGeocoderResult>: %@, %@, %f, %f", self.name, self.streetAddress, self.coordinate.latitude, self.coordinate.longitude];
}
@end


#pragma mark - XGeocoder

@interface XGeocoder ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic)		  BOOL		 activeRequest; ///< do we currently have an active request?

+ (XGeocoder *)sharedInstance;
@end

@implementation XGeocoder

+ (XGeocoder *)sharedInstance {
	return [super sharedInstance];
}

- (id)init {
	if (self = [super init]) {
		self.geocoder = [[CLGeocoder alloc] init];
	}
	return self;
}

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(XReverseGeocdoingCompletionBlock)completionBlock {
//	XLog(self, LogFlagInfo, @"Reverse geocoding %f, %f", coordinate.latitude, coordinate.longitude);
	if ([self sharedInstance].activeRequest) {
//		XLog(self, LogFlagInfo, @"An existing geocoding request has been canceled.");
		[[self sharedInstance].geocoder cancelGeocode];
	}
	
	[self sharedInstance].activeRequest = YES;
	[[self sharedInstance].geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
		[self sharedInstance].activeRequest = NO;
		
		if (error || !placemarks[0]) {
			completionBlock(nil);
			return;
		}
		CLPlacemark *placemark = placemarks[0];
		NSString *address = placemark.addressDictionary[@"Street"]; // <- what's the real constant key
//		XLog(self, LogFlagInfo, @"Reverse geocoding result: %@", address);
		completionBlock(address);
	}];
}

+ (void)geocodeStreetAddress:(NSString *)requestedAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode
					 country:(NSString *)country inRegion:(CLRegion *)region completion:(XGeocodingCompletionBlock)completionBlock {
	
//	XLog(self, LogFlagDebug, @"geocoding %@, %@, %@, %@, %@", requestedAddress, city, state, zipCode, country);
	
	if ([self sharedInstance].activeRequest) {
//		XLog(self, LogFlagDebug, @"An existing geocoding request has been canceled.");
		[[self sharedInstance].geocoder cancelGeocode];
	}
	[self sharedInstance].activeRequest = YES;
	
	NSMutableDictionary *addressDict = @{}.mutableCopy;
	if (requestedAddress.length)	addressDict[(NSString *)kABPersonAddressStreetKey]	= requestedAddress;
	if (city.length)				addressDict[(NSString *)kABPersonAddressCityKey]	= city;
	if (state.length)				addressDict[(NSString *)kABPersonAddressStateKey]	= state;
	if (zipCode)					addressDict[(NSString *)kABPersonAddressZIPKey]		= zipCode;
	if (country)					addressDict[(NSString *)kABPersonAddressCountryKey] = country;
	
	[[self sharedInstance].geocoder geocodeAddressDictionary:addressDict completionHandler:^(NSArray *placemarks, NSError *error) {
		[self sharedInstance].activeRequest = NO;
		
        if (error || placemarks.count == 0) {
            completionBlock(nil);
            return;
        }
		
//		XLog(self, LogFlagDebug, @"%d results for '%@' geocoding", placemarks.count, addressDict);
        
        NSMutableArray *results = [NSMutableArray array];
        for (CLPlacemark *placemark in placemarks) {
            NSString *actualStreetAddress = nil;
            if (placemark.thoroughfare && placemark.subThoroughfare) {
                actualStreetAddress = [NSString stringWithFormat:@"%@ %@", [placemark subThoroughfare] /* 937A */, [placemark thoroughfare] /* Howard St */];
            } else if (placemark.thoroughfare) {
                actualStreetAddress = placemark.thoroughfare;
            } else if (placemark.subThoroughfare) {
                actualStreetAddress = placemark.subThoroughfare;
            }
			// want our name to be something like '937A Howard', otherwise try for placemark name (probably nil), otherwise just take the first part of whatever the user typed in
			NSString *name = actualStreetAddress.length ? actualStreetAddress : placemark.name.length ? placemark.name : requestedAddress;
			
            if (placemark.locality) {
                if (actualStreetAddress) {
                    actualStreetAddress = [actualStreetAddress stringByAppendingFormat:@", %@", placemark.locality];
                } else {
                    actualStreetAddress = placemark.locality;
                }
            }
            if (placemark.administrativeArea) {
                if (actualStreetAddress) {
                    actualStreetAddress = [actualStreetAddress stringByAppendingFormat:@", %@", placemark.administrativeArea];
                } else {
                    actualStreetAddress = placemark.administrativeArea;
                }
            }
			XGeocoderResult *result = [[XGeocoderResult alloc] init];
			result.streetAddress = actualStreetAddress;
			result.name = name;
			result.city = placemark.locality;
			result.state = placemark.administrativeArea;
			result.country = placemark.country;
			result.coordinate = placemark.location.coordinate;
			[results addObject:result];
        }
        completionBlock(results);
    }];
}


@end
