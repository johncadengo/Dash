//
//  Flag+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Flag+Helper.h"

@implementation Flag (Helper)

- (void)setUid:(NSNumber *)uid timestamp:(NSDate *)timestamp text:(NSString *)text
{
    [self setUid:uid];
    [self setTimestamp:timestamp];
    [self setText:text];
}

@end
