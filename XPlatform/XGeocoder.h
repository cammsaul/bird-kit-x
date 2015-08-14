//
//  XGeocoder.h
//  Cam Saül
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#include "XSingleton.h"

typedef void(^XReverseGeocdoingCompletionBlock)(NSString *addressOrNil);
typedef void(^XGeocodingCompletionBlock)(NSArray *results);

@interface XGeocoderResult : NSObject
- (NSString *)name;						///< Name of the location of the geocoder result
- (NSString *)streetAddress;			///< full street address (!), e.g. '937 Howard St, San Francisco, CA'
- (NSString *)city;						///< City of the geocoder result
- (NSString *)state;					///< state or provience e.g. 'CA'
- (NSString *)country;					///< e.g. 'United States' (?)
- (CLLocationCoordinate2D)coordinate;	///< Coordinate of the geocoder results
@end

@interface XGeocoder : XSingleton

/// According to Apple, you can only have one reverse geocoding request at any given moment, so calling this will cancel any exisiting requests (completion block will return nil).
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completion:(XReverseGeocdoingCompletionBlock)completionBlock;

/// Geocodes address. City/State/Zip/Country/Region are all optional.
/// If you don't provie a country, will default to 'United States'.
/// Returns an array of XGeocoder results.
+ (void)geocodeStreetAddress:(NSString *)streetAddress city:(NSString *)city state:(NSString *)state zipCode:(NSNumber *)zipCode country:(NSString *)country inRegion:(CLRegion *)region completion:(XGeocodingCompletionBlock)completionBlock;

@end
