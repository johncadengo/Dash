//
//  NSArray+Helpers.m
//  Dash
//
//  Created by John Cadengo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Helpers.h"
#import "NSString+RandomStrings.h"

@implementation NSArray (Random)

+(id)arrayWithCount:(int)count ofRandomStringsOfLength:(int)len
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    // Make sure len is at least 1
    ++len;
    
    for (int i=0; i<count; ++i) {
        [arr addObject: [NSString genRandStringLength:arc4random()%len]];
    }
    
    return [NSArray arrayWithArray:arr];
}


-(id)randomObject
{
    NSUInteger randomIndex = arc4random() % [self count];
    return [self objectAtIndex:randomIndex];
}

@end
