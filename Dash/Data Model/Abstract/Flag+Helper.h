//
//  Flag+Helper.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Flag.h"

@interface Flag (Helper)

/** Sets the attributes of a flag at one time: uid, timestamp, and text.
 */
- (void)setUid:(NSNumber *)uid timestamp:(NSDate *)timestamp text:(NSString *)text;

@end
