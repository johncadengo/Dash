//
//  DashTests.m
//  DashTests
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashTests.h"

@implementation DashTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    NSLog(@"%@ setUp", self.name);
//    calculator = [[[Calculator alloc] init] retain];
//    STAssertNotNil(calculator, @"Cannot create Calculator instance");
}

- (void)tearDown
{
//    [calculator release];
//    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in DashTests");
}

@end
