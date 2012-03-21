//
//  Place+Place_Helper.h
//  Dash
//
//  Created by John Cadengo on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place.h"

@interface Place (Helper)

- (NSString*)categoriesDescriptionShort;
- (NSString*)categoriesDescriptionLong;
- (NSString*)categoriesDescriptionWithLimit:(NSInteger)limit;

@end
