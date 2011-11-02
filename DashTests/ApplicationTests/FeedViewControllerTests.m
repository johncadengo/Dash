//
//  FeedViewControllerTests.m
//  Dash
//
//  Created by John Cadengo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedViewControllerTests.h"

#import <UIKit/UIKit.h>
//#import "application_headers" as required

@implementation FeedViewControllerTests

// All code under test is in the iOS Application
- (void)testAppDelegate
{
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

@end
