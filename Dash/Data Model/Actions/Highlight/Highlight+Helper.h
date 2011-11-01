//
//  Highlight+Helper.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Highlight.h"

@interface Highlight (Helper)

/** Sets everything all at the same time.
 */
- (void)setUID:(NSNumber *)uid timestamp:(NSDate *)time text:(NSString *)text;

@end
