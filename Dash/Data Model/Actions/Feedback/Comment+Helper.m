//
//  Comment+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Comment+Helper.h"

@implementation Comment (Helper)

- (void)setUid:(NSNumber *)uid timestamp:(NSDate *)timestamp text:(NSString *)text
{
    [self setUid:uid];
    [self setTimestamp:timestamp];
    [self setText:text];
}

- (NSString *)description
{
    return [self text];
}

@end
