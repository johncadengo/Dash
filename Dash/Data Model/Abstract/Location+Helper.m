//
//  Location+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Location+Helper.h"

@implementation Location (Helper)

-(NSNumber *)degreesToRadians:(NSNumber *)degrees
{
    double radians = ([degrees doubleValue] * M_PI) / 180.0;
    return [NSNumber numberWithDouble: radians];
}

- (void)setLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
{
    [self setLatitude:latitude];
    [self setLongitude:longitude];
    
    // Make calculations
    double radLat = [[self degreesToRadians:latitude] doubleValue];
    double radLng = [[self degreesToRadians:longitude] doubleValue];
    double cosRadLat = cos(radLat);
    double sinRadLat = sin(radLat);
    
    //NSLog(@"%d")
    
    // and set their values
    [self setRadLat:[NSNumber numberWithDouble:radLat]];
    [self setRadLng:[NSNumber numberWithDouble:radLng]];
    [self setCosRadLat:[NSNumber numberWithDouble:cosRadLat]];
    [self setSinRadLat:[NSNumber numberWithDouble:sinRadLat]];
}

- (NSNumber *)distanceFrom:(Location *)location
{
    return nil;
}

@end
