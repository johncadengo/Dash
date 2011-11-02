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

- (NSMutableArray *)feedForPerson:(Person *)person
{
    NSMutableArray *feed = [[NSMutableArray alloc] initWithCapacity: 1];

    return feed;
}

@end
