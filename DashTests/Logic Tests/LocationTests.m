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
#import "Place.h"

@implementation LocationTests

// Constants we will check to ensure our calcluations are correct
// 226 Thomson St 10012
double const LAT = 40.7292540;
double const LNG = -73.9988530;
double const RAD_LAT = 0.710859584;
double const RAD_LNG = -1.29152363;
double const SIN_RAD_LAT = 0.652485406;
double const COS_RAD_LAT = 0.75780129;
double const accuracy = 0.00000001;

// 117 MacDougal St 10012
double const MACLAT = 40.7302133;
double const MACLNG = -74.0003337;

// Distance
double const DIST = 0.102;
double const DISTACC = 0.001;

#pragma mark -
#pragma mark Setup and TearDown

/** Run before each test. Populates the database with objects to play with.
 */
- (void)setUp
{
    NSLog(@"%@ setUp", self.name);
    
    // Creates our persistent store in memory and initializes our managed object context for us.
    [super setUp];
    
    // Create a new Location, PlaceLocation because Location is abstract!
    PlaceLocation *location = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceLocation" inManagedObjectContext:self.managedObjectContext];
    
    // Using the setLatitude:longitude: method, which cascades the calculation for all other values
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
    
    // Create a fictional Place
    Place *place = (Place *)[NSEntityDescription insertNewObjectForEntityForName: @"Place" inManagedObjectContext: self.managedObjectContext];
    [place setUid: [NSNumber numberWithInt: 2]];
    [place setAddress: @"226 Thompson St 10012"];
    STAssertNotNil([place address], @"Address failed to stick.");
    
    // Before saving, attach the Location to the Place
    [place setLocation: location];
    
    // Saves the managed object context into the persistent store.
    [self saveContext];
}

/** Run after each test, makes sure to dispose of everything we've created during setup.
 
    TODO: Actually tear down things. Right now, it does not.
 */
- (void)tearDown
{
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

#pragma mark -
#pragma mark Tests

/** Tests to see if the values stick after saving and fetching
 */
- (void)testCalculatedValuesStick
{
    PlaceLocation *location = [self fetchLastPlaceLocation];
    
    NSLog(@"Stick: %@", location);
    
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

/** Tests the greatCircleDistance method of the Location class
 */
/*
- (void)testGreatCircleDistanceCalculation
{
    NSLog(@"%@ testGreatcircleDistanceCalculation", self.name);
    
    PlaceLocation *twoTwoSixThompson = [self fetchLastPlaceLocation];
    
    // Create a new location
    PlaceLocation *location = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceLocation" inManagedObjectContext:self.managedObjectContext];
    
    // Using the setLatitude:longitude: method, which cascades the calculation for all other values
    [location setLatitude:[NSNumber numberWithDouble:MACLAT] longitude:[NSNumber numberWithDouble:MACLNG]];
    
    // Create its place
    Place *place = (Place *)[NSEntityDescription insertNewObjectForEntityForName: @"Place" inManagedObjectContext: self.managedObjectContext];
    [place setUid: [NSNumber numberWithInt: 2]];
    [place setAddress: @"117 MacDougal St 10012"];
    
    // Attach it
    [place setLocation:location];
    
    // Save it, then calculate
    [self saveContext];
    
    // Now calculate the great circle distance between the two
    NSNumber *distance = [twoTwoSixThompson greatCircleDistanceFrom:location];
    double d = [distance doubleValue];
    
    // Check it
    NSLog(@"%@ %@ %@ %@", [twoTwoSixThompson latitude], [twoTwoSixThompson longitude],
          [location latitude], [location longitude]);
    STAssertNotNil([twoTwoSixThompson latitude], @"Latitude nil");
    STAssertNotNil([twoTwoSixThompson longitude], @"Longitude nil");
    STAssertNotNil([location latitude], @"Latitude nil");
    STAssertNotNil([location longitude], @"Longitude nil");
    STAssertNotNil(twoTwoSixThompson, @"226 Thompson is nil");
    STAssertNotNil(location, @"117 MacDougal is nil");
    STAssertEqualsWithAccuracy(DIST, d, DISTACC, @"Wanted: %f Got: %f", DIST, d);
}*/


@end
