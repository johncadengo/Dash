//
//  Location+Helper.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@interface Location (Helper)

- (NSNumber *)degreesToRadians:(NSNumber *)degrees;
- (void)setLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end
