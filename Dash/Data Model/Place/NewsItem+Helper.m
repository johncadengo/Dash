//
//  NewsItem+Helper.m
//  Dash
//
//  Created by John Cadengo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsItem+Helper.h"
#import "NSDate+RandomDates.h"

@implementation NewsItem (Helper)

- (NSString *)relativeTimestamp
{
    NSString *time = [NSString stringWithFormat:@"%@", [self.timestamp relativeTimestamp]];
    return time;
}

- (NSComparisonResult)compare:(NewsItem *)other
{
    return [self.timestamp compare:other.timestamp];
}

@end
