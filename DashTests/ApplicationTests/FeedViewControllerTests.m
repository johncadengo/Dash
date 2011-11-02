//
//  FeedViewControllerTests.m
//  Dash
//
//  Created by John Cadengo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedViewControllerTests.h"

#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@implementation FeedViewControllerTests

@synthesize feedViewController = _feedViewController;

#pragma mark -
#pragma mark Setup and TearDown

/** Run before each test. Populates the database with objects to play with.
 */
- (void)setUp
{
    NSLog(@"%@ setUp", self.name);
    
    // Creates our persistent store in memory and initializes our managed object context for us.
    [super setUp];
    
    // Get the application delegate
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
    // Set the feed view controller
    UITabBarController *tabBarController = (UITabBarController *)[[yourApplicationDelegate window] rootViewController];
    UINavigationController *navController = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:0];
    self.feedViewController = (FeedViewController *)[navController topViewController];
    STAssertNotNil(self.feedViewController, @"Could not obtain the FeedViewController");
}

/** Run after each test, makes sure to dispose of everything we've created during setup.
 
    TODO: Actually tear down things. Right now, it does not.
 */
- (void)tearDown
{
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

#pragma mark -
#pragma mark Tests

- (void)testFeedViewModel
{
    NSLog(@"%@", self.name);
    
    NSMutableArray *feedItems = [self.feedViewController feedItems];
    NSUInteger count = [feedItems count];
    STAssertTrue(count, @"There are no items in the feedItems array: %d", count);
}

@end
