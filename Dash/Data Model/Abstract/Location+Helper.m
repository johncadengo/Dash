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

- (void)setWithCLLocation:(CLLocation *)location
{
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    
    [self setLatitude:latitude longitude:longitude]; 
}

/** Cascades the calculations of the other values which rely on latitude automatically
 */
- (void)setLatitude:(NSNumber *)latitude
{
    // Begin changing values
    [self willChangeValueForKey:@"latitude"];
    [self willChangeValueForKey:@"radLat"];
    [self willChangeValueForKey:@"cosRadLat"];
    [self willChangeValueForKey:@"sinRadLat"];
    
    // Make calculations
    double dblRadLat = [self degreesToRadians:latitude];
    double dblCosRadLat = cos(dblRadLat);
    double dblSinRadLat = sin(dblRadLat);
    
    // Set their values
    [self setPrimitiveValue:latitude forKey:@"latitude"];
    [self setPrimitiveValue:[NSNumber numberWithDouble:dblRadLat] forKey:@"radLat"];
    [self setPrimitiveValue:[NSNumber numberWithDouble:dblCosRadLat] forKey:@"cosRadLat"];
    [self setPrimitiveValue:[NSNumber numberWithDouble:dblSinRadLat] forKey:@"sinRadLat"];
    
    // And let it know we are done
    [self didChangeValueForKey:@"latitude"];
    [self didChangeValueForKey:@"radLat"];
    [self didChangeValueForKey:@"cosRadLat"];
    [self didChangeValueForKey:@"sinRadLat"];
}

/** Cascades the calculations of the other values which rely on longitude automatically
 */
- (void)setLongitude:(NSNumber *)longitude 
{
    // Begin changing values
    [self willChangeValueForKey:@"longitude"];
    [self willChangeValueForKey:@"radLng"];
    
    // Make calculations
    double dblRadLng = [self degreesToRadians:longitude];
    
    // Set their values
    [self setPrimitiveValue:longitude forKey:@"longitude"];
    [self setPrimitiveValue:[NSNumber numberWithDouble:dblRadLng] forKey:@"radLng"];
    
    // And let it know we are done
    [self didChangeValueForKey:@"longitude"];
    [self didChangeValueForKey:@"radLng"];
}

- (void)setLatitude:(NSNumber *)newLat longitude:(NSNumber *)newLng
{
    [self setLatitude:newLat];
    [self setLongitude:newLng];
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
