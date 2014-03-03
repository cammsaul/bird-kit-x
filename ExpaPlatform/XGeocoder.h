//
//  XGeocoder.h
//  Expa
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

typedef void(^XReverseGeocdoingCompletionBlock)(NSString *addressOrNil);
typedef void(^XGeocodingCompletionBlock)(NSArray *results);

@interface XGeocoderResult : NSObject
/// Name of the location of the geocoder result
- (NSString *)name;
/// Street address of the geocoder result
- (NSString *)streetAddress;
/// City of the geocoder result
- (NSString *)city;
/// Coordinate of the geocoder results
- (CLLocationCoordinate2D)coordinate;
@end

@interface XGeocoder : NSObject

/// According to Apple, you can only have one reverse geocoding request at any given moment, so calling this will cancel any exisiting requests (completion block will return nil).
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(XReverseGeocdoingCompletionBlock)completionBlock;

/// Geocodes address. City/State/Zip/Country/Region are all optional.
/// If you don't provie a country, will default to 'United States'.
/// Returns an array of XGeocoder results.
+ (void)geocodeStreetAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode country:(NSString *)country inRegion:(CLRegion *)region completion:(XGeocodingCompletionBlock)completionBlock;

@end
