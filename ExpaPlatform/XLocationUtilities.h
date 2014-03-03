//
//  XLocationUtilities.h
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import <MapKit/MapKit.h>

#ifdef __cplusplus
	extern "C" {
#endif

/// Fast method to calculate distance between coordinates. Uses Haversine formula, but if that fails, tries Spherical Law of Cosines.
/// Assumes coordinates are both valid. (this is in meters)
float distance_between_coordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);

float latitude_span_to_meters(float latitudeSpan);

inline float meters_to_latitude_span(float meters);

float meters_to_miles(float meters);

int meters_to_minutes_walk(int meters);

/// returns a MKCoordinate region centered between the two coordinates, large enough to display both coordinates.
MKCoordinateRegion MKCoordinateRegionForCoordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);

/// returns YES if the coordinates are equal
BOOL CLLocationCoordinatesEqual(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2);

#ifdef __cplusplus
	}
#endif