//
//  Comment+Helper.h
//  Dash
//
//  Created by John Cadengo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Comment.h"
#import "Action+Helper.h"

@class Highlight;
@class Person;

@interface Comment (Helper) <Description>

/** Sets the attributes of a Highlight at one time: uid, timestamp, and text.
 */
- (void)setUid:(NSNumber *)uid timestamp:(NSDate *)timestamp text:(NSString *)text;

/** This is what is shown
 */
- (NSString *)description;
@end
