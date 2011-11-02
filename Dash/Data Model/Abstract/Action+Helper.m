//
//  Action+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Action+Helper.h"

@implementation Action (Helper)

- (void)setUid:(NSNumber *)uid timestamp:(NSDate *)timestamp
{
    [self setUid:uid];
    [self setTimestamp:timestamp];
}

- (void)connect:(Person *)person toPlace:(Place *)place
{
    
}

#pragma - Footprints

- (NSString *)photoPath
{
    return [NSString stringWithFormat:@"icon.png"];    
}

// TODO: Branch depending on what kind of Action is taking places. For now, stub.
- (NSString *)blurb
{
    return [NSString stringWithFormat: @"Laura Byun likes lemonade with mint tea leaves."];
    
}

- (NSString *)relativeTimestamp
{
    return [NSString stringWithFormat: @"2 days ago"];    
}

@end
