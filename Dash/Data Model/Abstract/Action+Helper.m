//
//  Action+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Action+Helper.h"
#import "NSDate+RandomDates.h"

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
- (NSString *)description
{
    return [NSString stringWithFormat: @"Laura Byun likes lemonade with mint tea leaves."];
    
}

- (NSString *)relativeTimestamp
{
    return [self.timestamp relativeTimestamp];
}

- (NSString *)feedbackActivity 
{
    return [NSString stringWithFormat:@"3 comments, %d likes", 1 + arc4random() % 10];
}


@end
