//
//  XLocationUtilities.m
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XLocationUtilities.h"

inline float distance_between_coordinates(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
	static const int RADIUS = 6371000; // Earth's radius in meters
	static const float RAD_PER_DEG = 0.017453293f;
	
	const float lat1 = coordinate1.latitude;
	const float lat2 = coordinate2.latitude;
	const float lon1 = coordinate1.longitude;
	const float lon2 = coordinate2.longitude;
	
	const float dlat = lat2 - lat1;
	const float dlon = lon2 - lon1;
	
	const float dlon_rad = dlon * RAD_PER_DEG;
	const float dlat_rad = dlat * RAD_PER_DEG;
	const float lat1_rad = lat1 * RAD_PER_DEG;
	const float lon1_rad = lon1 * RAD_PER_DEG;
	const float lat2_rad = lat2 * RAD_PER_DEG;
	const float lon2_rad = lon2 * RAD_PER_DEG;
	
	const float a = pow((sinf(dlat_rad/2.0f)), 2.0f) + cosf(lat1_rad) * cosf(lat2_rad) * pow(sinf(dlon_rad/2.0f),2.0f);
	const float c = 2.0f * atan2f( sqrt(a), sqrt(1.0f-a));
	float d = RADIUS * c;
	
	if (isnan(d)) {
		// for some reason Haversine formula failed, let's do Spherical Law of Cosines
		d = acosf(sinf(lat1_rad)*sinf(lat2_rad) + cosf(lat1_rad)*cosf(lat2_rad) * cosf(lon2_rad-lon1_rad)) * RADIUS;
	}
    return d; // Return our calculated distance
}

inline float latitude_span_to_meters(float latitudeSpan) {
	const float metersPerLatitudeDegree = 111000; // 1 degree lat is always 111km
	return metersPerLatitudeDegree * latitudeSpan;
}

inline float meters_to_latitude_span(float meters) {
	const float metersPerLatitudeDegree = 111000; // 1 degree lat is always 111km
	return meters / metersPerLatitudeDegree;
}

float meters_to_miles(float meters) {
	return meters * 0.000621371192;
}

inline int meters_to_minutes_walk(int meters) {
	static const int AverageHumanWalkingSpeedMetersPerMinute = 2.7 * 1600.0 / 60.0; // 2.7mph * 1600 meters/mile ÷ minutes per hour
	return meters / AverageHumanWalkingSpeedMetersPerMinute;
}

MKCoordinateRegion MKCoordinateRegionForCoordinates(CLLocationCoordinate2D c1, CLLocationCoordinate2D c2) {
	const CLLocationCoordinate2D center = CLLocationCoordinate2DMake((c1.latitude + c2.latitude) / 2.0, (c1.longitude + c2.longitude) / 2.0);
	const float dist = distance_between_coordinates(c1, c2) * 1.25f; // zoom out a little bit so they both fit on screen
	return MKCoordinateRegionMakeWithDistance(center, dist, dist);
}

BOOL CLLocationCoordinatesEqual(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2) {
	return coordinate1.latitude == coordinate2.latitude && coordinate1.longitude == coordinate2.longitude;
}
