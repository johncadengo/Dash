//
//  DashAPI.m
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashAPI.h"
#import "JSONKit.h"

@implementation DashAPI

@synthesize JSON = _JSON;

-(id) init 
{
    self = [super init];
    
    if (self) {
        self.JSON = [[JSONDecoder alloc] init];
    }
    
    return self;
}

@end
