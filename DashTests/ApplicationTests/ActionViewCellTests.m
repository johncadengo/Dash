//
//  ActionViewCellTests.m
//  Dash
//
//  Created by John Cadengo on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionViewCellTests.h"

#import <UIKit/UIKit.h>
#import "ActionViewCell.h"
#import "FeedViewController.h"
//#import "application_headers" as required

@implementation ActionViewCellTests

@synthesize actionViewCell = _actionViewCell;

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
    FeedViewController *feedViewController = (FeedViewController *)[navController topViewController];
    STAssertNotNil(feedViewController, @"Could not obtain the FeedViewController");
    
    // Grab the first action view cell we encounter
    self.actionViewCell = (ActionViewCell *)[feedViewController feedCellForTableView:feedViewController.tableView forRow:0];
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

/** Tests to make sure that each type works and that if we pass a type that doesn't exist it returns nil
 */
- (void)testActionTableViewCellTypes
{
    ActionViewCell *actionViewCell = [[ActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestIdentifier" actionViewCellType:ActionViewCellTypeHeader];
    STAssertNotNil(actionViewCell, @"Failed to initialize a properly typed action view cell");
    
    // Using default initializer
    actionViewCell = [[ActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestIdentifier"];
    ActionViewCellType cellType = actionViewCell.cellType;
    STAssertEquals(cellType, ActionViewCellTypeHeader, @"Failed to catch an invalid ActionViewCellType and set it to the default value of header cell. Wanted %d Got: %d", ActionViewCellTypeHeader, cellType);
    
    // Using custom initializer
    actionViewCell = [[ActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestIdentifier" actionViewCellType:kNumActionViewCellTypes];
    cellType = actionViewCell.cellType;
    STAssertEquals(cellType, ActionViewCellTypeHeader, @"Failed to catch an invalid ActionViewCellType and set it to the default value of header cell. Wanted %d Got: %d", ActionViewCellTypeHeader, cellType);
    
}

@end
