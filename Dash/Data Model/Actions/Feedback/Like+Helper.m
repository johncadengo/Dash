//
//  Like+Helper.m
//  Dash
//
//  Created by John Cadengo on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Like+Helper.h"
#import "Person.h"
#import "Person+Helper.h"

@implementation Like (Helper)

- (NSString *)description
{
    NSString *subject = [NSString stringWithFormat:@"%@", self.author.name];
    NSString *object = [NSString stringWithFormat:@"%@", self.action];
    
    return [NSString stringWithFormat:@"%@ likes %@", subject, object];
}

@end
