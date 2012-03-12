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
#import "Highlight.h"
#import "Highlight+Helper.h"
#import "Place.h"
#import "Place+Helper.h"

@implementation Like (Helper)

- (NSString *)description
{
    NSString *subject = [NSString stringWithFormat:@"%@", self.author.name];
    NSString *object = [NSString stringWithFormat:@"%@", self.action];
    
    Highlight *highlight = (Highlight *)self.action;
    NSString *source = [NSString stringWithFormat:@"%@", highlight.place.name];
    
    return [NSString stringWithFormat:@"%@ likes %@ at %@", subject, object, source];
}

@end
