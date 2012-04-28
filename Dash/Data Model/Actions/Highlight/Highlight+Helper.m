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

- (NSString *)description
{
    return [self text];
}

- (BOOL)likedByMe
{
    return [[self.likes objectsPassingTest:^BOOL(id obj,BOOL *stop){
            Person *author = (Person *)obj;
            Person *me = DashAPI.me;
            return ([me.fb_uid isEqualToString:author.fb_uid]) ? YES : NO;
            }] count];
}

@end
