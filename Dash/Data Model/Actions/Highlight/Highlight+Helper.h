//
//  Highlight+Helper.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Highlight.h"
#import "Action+Helper.h"

@class Person;
@class Place;
@class HighlightPhoto;

@interface Highlight (Helper) <Description>

/** Sets the attributes of a Highlight at one time: uid, timestamp, and text.
 */
- (void)setUid:(NSNumber *)uid timestamp:(NSDate *)timestamp text:(NSString *)text;

/** This is what is shown
 */
- (NSString *)description;

@end
