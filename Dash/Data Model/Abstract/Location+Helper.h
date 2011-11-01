//
//  Location+Helper.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@interface Location (Helper)

/** Transforms degrees to radians. Needed to do sin and cos calculations.
 */
- (NSNumber *)degreesToRadians:(NSNumber *)degrees;

/** Sets the attributes of a Location at one time: latitude, longitude.
    Also calculates the other values as well for radians, cos, etc.
 */
- (void)setLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end
