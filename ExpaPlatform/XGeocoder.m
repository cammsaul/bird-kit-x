//
//  XGeocoder.m
//  Expa
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import "XGeocoder.h"
#import "XLogging.h"
#import "NSMutableArray+Expa.h"
#import "XLocationUtilities.h"

static CLGeocoder *__geocoder;
static BOOL __activeRequest;

@interface XGeocoderResult ()
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *streetAddress;
@property (nonatomic, strong, readwrite) NSString *city;
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

@implementation XGeocoder

+ (void)load {
	__geocoder = [[CLGeocoder alloc] init];
}

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(XReverseGeocdoingCompletionBlock)completionBlock {
//	XLog(self, LogFlagInfo, @"Reverse geocoding %f, %f", coordinate.latitude, coordinate.longitude);
	if (__activeRequest) {
//		XLog(self, LogFlagInfo, @"An existing geocoding request has been canceled.");
		[__geocoder cancelGeocode];
	}
	
	__activeRequest = YES;
	[__geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
		__activeRequest = NO;
		
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

+ (void)geocodeStreetAddress:(NSString *)requestedStreetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode
					 country:(NSString *)country inRegion:(CLRegion *)region completion:(XGeocodingCompletionBlock)completionBlock {
	
//	XLog(self, LogFlagInfo, @"geocoding %@, %@, %@, %@, %@", requestedStreetAddress, city, state, zipCode, country);
	
	if (__activeRequest) {
//		XLog(self, LogFlagInfo, @"An existing geocoding request has been canceled.");
		[__geocoder cancelGeocode];
	}
	__activeRequest = YES;
	
	if (city.length) {
		requestedStreetAddress = [requestedStreetAddress stringByAppendingFormat:@", %@", city];
	}
	if (state.length) {
		requestedStreetAddress = [requestedStreetAddress stringByAppendingFormat:@", %@", state];
	}
	if (zipCode) {
		requestedStreetAddress = [requestedStreetAddress stringByAppendingFormat:@" %@", [zipCode description]];
	}
	if (!country) country = @"United States";
	requestedStreetAddress = [requestedStreetAddress stringByAppendingFormat:@", %@", country];
	
	[__geocoder geocodeAddressString:requestedStreetAddress inRegion:region completionHandler:^(NSArray *placemarks, NSError *error) {
		__activeRequest = NO;
		
        if (error || placemarks.count == 0) {
            completionBlock(nil);
            return;
        }
		
//		XLog(self, LogFlagInfo, @"%d results for '%@' geocoding", placemarks.count, requestedStreetAddress);
        
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
			NSString *name = actualStreetAddress.length ? actualStreetAddress : placemark.name.length ? placemark.name : [requestedStreetAddress componentsSeparatedByString:@","][0];
			
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
			result.coordinate = placemark.location.coordinate;
			[results addObject:result];
        }
        completionBlock(results);
    }];
}


@end
