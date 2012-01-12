//
//  Location+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Location+Helper.h"

@implementation Location (Helper)

- (double)degreesToRadians:(NSNumber *)degrees
{
    double radians = ([degrees doubleValue] * M_PI) / 180.0;
    return radians;
}
/*
- (void)setWithCLLocation:(CLLocation *)location
{
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    
    [self setLatitude:latitude longitude:longitude]; 
}*/

- (void)setLatitude:(NSNumber *)newLat longitude:(NSNumber *)newLng
{
    [self setLatitude:newLat];
    [self setLongitude:newLng];
    
    // Make calculations
    double dblRadLat = [self degreesToRadians:newLat];
    double dblRadLng = [self degreesToRadians:newLng];
    double dblCosRadLat = cos(dblRadLat);
    double dblSinRadLat = sin(dblRadLat);

    // and set their values
    [self setRadLat:[NSNumber numberWithDouble:dblRadLat]];
    [self setRadLng:[NSNumber numberWithDouble:dblRadLng]];
    [self setCosRadLat:[NSNumber numberWithDouble:dblCosRadLat]];
    [self setSinRadLat:[NSNumber numberWithDouble:dblSinRadLat]];
}

 - (NSNumber *)greatCircleDistanceFrom:(Location *)other
{
    NSLog(@"Self: %@", self);
    NSLog(@"Other: %@", other);
    NSAssert(other, @"Other is nil");
    
    // Unpack all the NSNumbers into doubles so we can manipulate them
    double selfCosRadLat = [self.cosRadLat doubleValue];
    double otherCosRadLat = [other.cosRadLat doubleValue];
    double selfRadLng = [self.radLng doubleValue];
    double otherRadLng = [other.radLng doubleValue];
    double selfSinRadLat = [self.sinRadLat doubleValue];
    double otherSinRadLat = [other.sinRadLat doubleValue];
    
    /*
     func.acos(  cls.cos_rad_lat 
     * other.cos_rad_lat 
     * func.cos(cls.rad_lng - other.rad_lng)
     + cls.sin_rad_lat
     * other.sin_rad_lat
     ) * 3959
     */
    
    // Multiplying by 3959 calculates the distance in miles.
    double d = acos(selfCosRadLat
                    * otherCosRadLat
                    * cos(selfRadLng - otherRadLng)
                    + selfSinRadLat
                    * otherSinRadLat
                    ) * 3959.0;
    
    return [NSNumber numberWithDouble:d];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Lat %@\nLng %@\nRadLat %@\nRadLng %@\nCosRadLat %@\nSinRadLat %@",
                      self.latitude, self.longitude, self.radLat, self.radLng, self.cosRadLat, self.sinRadLat];
    return desc;
}

@end
