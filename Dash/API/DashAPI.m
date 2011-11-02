//
//  DashAPI.m
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashAPI.h"
#import "Person.h"
#import "Person+Helper.h"
#import "Action.h"
#import "Action+Helper.h"


// Private properties
@interface DashAPI ()

@end

@implementation DashAPI

-(id) init 
{
    self = [super init];
    
    if (self) {
        return self;
    }
    
    return self;
}

-(void) pop:(CLLocation *)location
{
    
    
}

- (NSMutableArray *)feed
{
    return [self feedForPerson:nil withCount:kDefaultNumFeedItems];
}

- (NSMutableArray *)feedWithCount:(NSUInteger)count
{
    return [self feedForPerson:nil withCount:count];
}

- (NSMutableArray *)feedForPerson:(Person *)person
{
    return [self feedForPerson:person withCount:kDefaultNumFeedItems];
}

- (NSMutableArray *)feedForPerson:(Person *)person withCount:(NSUInteger)count
{
    // TODO: This is a stub for now. Actually request news items from model!
    Action *action;
    NSMutableArray *feed = [[NSMutableArray alloc] initWithCapacity:count];

    for (int i = 0; i < count; ++i) {
        action = [[Action alloc] init];
        [feed addObject:action];
    }
    
    return feed;
}

@end
