//
//  ActionViewControllerTests.m
//  Dash
//
//  Created by John Cadengo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HighlightViewControllerTests.h"

#import <UIKit/UIKit.h>
#import "HighlightViewController.h"
#import "FeedViewController.h"

#import "Highlight.h"
#import "Highlight+Helper.h"

@implementation HighlightViewControllerTests

@synthesize hightlightViewController = _hightlightViewController;

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
    
    FeedViewController *feedViewController = (FeedViewController *)[[navController viewControllers] objectAtIndex:0];
    
    [feedViewController tableView:feedViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    self.hightlightViewController = (HighlightViewController *)[navController topViewController];
    STAssertNotNil(self.hightlightViewController, @"Could not obtain the HighlightViewController");
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

/** Make sure an Action was properly assigned before the segue occurs.
 */
- (void)testPrepareSegue
{
    NSLog(@"%@", self.name);
    
    Action *action = self.hightlightViewController.action;
    STAssertNotNil(action, @"Highlight wasn't properly assigned prior to segue");
    
}

@end
