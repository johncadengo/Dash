//
//  Location+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Location+Helper.h"

@interface Location ()
-(double)degreesToRadians:(double)degrees;
@end

@implementation Location (Helper)

-(double)degreesToRadians:(double)degrees
{
    return degrees * M_PI / 180;
}

- (void)setLatitude:(double)latitude longitude:(double)longitude
{
    [self setLatitude:latitude];
    [self setLongitude:longitude];
    
    // Make calculations and set their values
    [self setRadLat:[self degreesToRadians:latitude]];
    [self setRadLng:[self degreesToRadians:longitude]];
    [self setCosRadLat:cos(self.radLat)];
    [self setSinRadLat:cos(self.radLat)];
}

@end
