//
//  Highlight+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Highlight+Helper.h"
#import "DashAPI.h"

@implementation Highlight (Helper)

- (void)setUid:(NSNumber *)uid timestamp:(NSDate *)timestamp text:(NSString *)text
{
    [self setUid:uid];
    [self setTimestamp:timestamp];
    [self setText:text];
}

- (BOOL)likedByMe
{
    return [[self.likes objectsPassingTest:^BOOL(id obj,BOOL *stop){
        Person *author = (Person *)obj;
        Person *me = DashAPI.me;
        return ([me.fb_uid isEqualToString:author.fb_uid]) ? YES : NO;
    }] count];
}

/** Want to prioritize highlights with likes.. Then after that just by id
 */
- (NSComparisonResult)compare:(Highlight *)other
{
    // First compare by likes, which are a clear winner
    NSComparisonResult result;
    
    if (self.likes.count < other.likes.count) {
        result = NSOrderedAscending;
    }
    else if (other.likes.count < self.likes.count) {
        result = NSOrderedDescending;
    }
    else {
        // Otherwise, they have equal number of likes.. so order by ID
        result = [self.uid compare:other.uid];
    }
    
    return result;
}

- (NSString *)description
{
    return [self text];
}


@end
