//
//  Action+Helper.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Action.h"

@class Person;
@class Place;

@interface Action (Helper)

/** Sets the attributes of an Action at one time: uid and timestamp.
 */
- (void)setUid:(NSNumber *)uid timestamp:(NSDate *)timestamp;

/** Sets the relationships of an Action.
    An Action exists between a Person and a Place. 
 
    TODO: Implement and write a test case for it.
 */
- (void)connect:(Person *)person toPlace:(Place *)place;

@end
