//
//  Highlight+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Highlight+Helper.h"

@implementation Highlight (Helper)

- (void)setUID:(NSNumber *)uid timestamp:(NSDate *)time text:(NSString *)text
{
    [self setUid: uid];
    [self setTimestamp: time];
    [self setText: text];
}

@end
