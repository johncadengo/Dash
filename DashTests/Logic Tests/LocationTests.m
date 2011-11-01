//
//  LocationTests.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationTests.h"
#import "Location.h"
#import "Location+Helper.h"
#import "PlaceLocation.h"

@implementation LocationTests

// Constants we will check to ensure our calcluations are correct
double const LAT = 40.7292540;
double const LNG = -73.9988530;
double const RAD_LAT = 0.710859584;
double const RAD_LNG = -1.29152363;
double const SIN_RAD_LAT = 0.652485406;
double const COS_RAD_LAT = 0.75780129;
double const accuracy = 0.00000001;

- (void)testSetLocationLongitude
{
    // Create a new Location, PlaceLocation because Location is abstract!
    PlaceLocation *location = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceLocation" inManagedObjectContext:self.managedObjectContext];
    
    // This is what we are testing: the setLatitude:longitude: method.
    [location setLatitude:[NSNumber numberWithDouble:LAT] longitude:[NSNumber numberWithDouble:LNG]];
    
    // Check if it has properly calculated the values we asked for
    double lat = [[location latitude] doubleValue];
    double lng = [[location longitude] doubleValue];
    double rad_lat = [[location radLat] doubleValue];
    double rad_lng = [[location radLng] doubleValue];
    double sin_rad_lat = [[location sinRadLat] doubleValue];
    double cos_rad_lat = [[location cosRadLat] doubleValue];
    
    STAssertEqualsWithAccuracy(LAT, lat, accuracy, @"Wanted: %f Got: %f", LAT, lat);
    STAssertEqualsWithAccuracy(LNG, lng, accuracy, @"Wanted: %f Got: %f", LNG, lng);
    STAssertEqualsWithAccuracy(RAD_LAT, rad_lat, accuracy, @"Wanted: %f Got: %f", RAD_LAT, rad_lat);
    STAssertEqualsWithAccuracy(RAD_LNG, rad_lng, accuracy, @"Wanted: %f Got: %f", RAD_LNG, rad_lng);
    STAssertEqualsWithAccuracy(SIN_RAD_LAT, sin_rad_lat, accuracy, @"Wanted: %f Got: %f", SIN_RAD_LAT, sin_rad_lat);
    STAssertEqualsWithAccuracy(COS_RAD_LAT, cos_rad_lat, accuracy, @"Wanted: %f Got: %f", COS_RAD_LAT, cos_rad_lat);
}

/** TODO: Make a function to calculate the distance between two Locations
    and create a test to make sure it works.
 */
- (void)testDistanceCalculation
{
    
}


@end
