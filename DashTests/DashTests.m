//
//  DashTests.m
//  DashTests
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashTests.h"
#import "DashAPI.h"

@implementation DashTests

@synthesize dash = _dash;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    NSLog(@"%@ setUp", self.name);
    self.dash = [[DashAPI alloc] init];
    STAssertNotNil(self.dash, @"Cannot create DashAPI instance");
}

- (void)tearDown
{
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

- (void)testDashInit
{
    // Make sure that all the ivars of dash have been initialized
    JSONDecoder *JSON = self.dash.JSON;
    STAssertNotNil(JSON, @"JSON ivar of DashAPI has not been initialized");
}

@end
