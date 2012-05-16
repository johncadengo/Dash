//
//  Badge+Helper.h
//  Dash
//
//  Created by John Cadengo on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Badge.h"

@interface Badge (Helper)

- (UIImage *)icon;
- (NSComparisonResult)compare:(Badge *)other;

@end
