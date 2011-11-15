//
//  JCImageGalleryViewControllerTests.m
//  Dash
//
//  Created by John Cadengo on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCImageGalleryViewControllerTests.h"

#import <UIKit/UIKit.h>
#import "JCImageGalleryViewController.h"
#import "FeedViewController.h"
#import "HighlightViewController.h"

@implementation JCImageGalleryViewControllerTests

@synthesize imageGalleryViewController = _imageGalleryViewController;

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

    // Perform selection of a feed item
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    [feedViewController tableView:nil didSelectRowAtIndexPath:indexPath];
    
    HighlightViewController *highlightViewController = (HighlightViewController *)[navController topViewController];
    self.imageGalleryViewController = highlightViewController.imageGalleryViewController;
    
    
    STAssertNotNil(self.imageGalleryViewController, @"Could not obtain the image gallery.");
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


@end
