//
//  DashAPI.h
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Person;

@interface DashAPI : NSObject

- (void)pop:(CLLocation *)location;

/** Returns an NSMutableArray of Footpring objects consisting of a Feed particular for a person.
 */
- (NSMutableArray *)feedForPerson:(Person *)person;

@end
