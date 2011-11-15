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
#import "JCViewController.h"
#import "JCPinholeViewController.h"
#import "JCGalleryViewController.h"
#import "JCSpotlightViewController.h"

#import "FeedViewController.h"
#import "HighlightViewController.h"
#import "Action.h"
#import "Action+Helper.h"
#import "Comment+Helper.h"
#import "Person+Helper.h"
#import "PersonPhoto+Helper.h"
#import "UIImage+ProportionalFill.h"

@implementation JCImageGalleryViewControllerTests

@synthesize imageGalleryViewController = _imageGalleryViewController;
@synthesize currentViewController = _currentViewController;
@synthesize pinholeViewController = _pinholeViewController;
@synthesize galleryViewController = _galleryViewController;
@synthesize spotlightViewController = _spotlightViewController;

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
    
    // Now the highlightviewcontroller is the topmost controller
    HighlightViewController *highlightViewController = (HighlightViewController *)[navController topViewController];

    // Make sure highlight view controller initializes the image gallery
    UITableViewCell *cell = [highlightViewController imageGalleryCellForTableView:highlightViewController.tableView];
    
    // Grab the image gallery view, and voila
    self.imageGalleryViewController = highlightViewController.imageGalleryViewController;
    STAssertNotNil(self.imageGalleryViewController, @"Could not obtain the image gallery.");
    
    // Grab the rest of the views
    self.pinholeViewController = self.imageGalleryViewController.pinholeViewController;
    self.galleryViewController = self.imageGalleryViewController.galleryViewController;
    self.spotlightViewController = self.imageGalleryViewController.spotlightViewController;
    STAssertNotNil(self.pinholeViewController, @"Pinhole failed");
    STAssertNotNil(self.galleryViewController, @"Gallery failed");
    STAssertNotNil(self.spotlightViewController, @"Spotlight failed");

    // Make sure current is set to a default mode
    STAssertNotNil(self.imageGalleryViewController.currentViewController, @"Current not set");
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

- (void)testInitWithImages
{
    NSLog(@"%@", self.name);
    
    // Get all the things that should be initialized and make sure they aren't nil
    NSMutableArray *imageViews = self.imageGalleryViewController.imageViews;
    UIView *topView = self.imageGalleryViewController.topView;
    UIView *superview = self.imageGalleryViewController.superview;
    UIView *view = self.imageGalleryViewController.view;
    
    STAssertNotNil(imageViews, @"ImageViews did not initailize");
    STAssertNotNil(topView, @"topView did not initailize");
    STAssertNotNil(superview, @"superview did not initailize");
    STAssertNotNil(view, @"view did not initailize");
    
    // Make sure that we conneceted our view to the superview
    UIView *viewssuper = view.superview;
    UIView *superssub = [[superview subviews] lastObject];
    STAssertEqualObjects(viewssuper, superview, @"View isn't connected to superview");
    STAssertEqualObjects(superssub, view, @"Superview isn't connected to view");
    
}

- (void)testSetState
{
    NSLog(@"%@", self.name);
    
    // Default state should be pinhole
    JCImageGalleryViewState state = JCImageGalleryViewStatePinhole;
    JCImageGalleryViewState currentState = self.imageGalleryViewController.state;
    STAssertEquals(state, currentState, @"Default state test. Wanted: %d Got: %d", state, currentState);
    
    // Test if we try to change state to what is already set
    [self.imageGalleryViewController setState:currentState];
    currentState = self.imageGalleryViewController.state;
    STAssertEquals(state, currentState, @"Redundant state change. Wanted: %d Got: %d", state, currentState);
    
    // Test if the amShowing is working properly in the default just initialized state
    BOOL amShowing = self.pinholeViewController.amShowing;
    STAssertTrue(amShowing, @"Pinhole controller's amShowing wrong: %d", amShowing);
    amShowing = self.galleryViewController.amShowing;
    STAssertFalse(amShowing, @"Gallery amShowing wrong: %d", amShowing);
    amShowing = self.spotlightViewController.amShowing;
    STAssertFalse(amShowing, @"Spotlight amShowing wrong: %d", amShowing);
    
    // Change the state from pinhole to gallery
    [self.imageGalleryViewController setState:JCImageGalleryViewStateGallery];
    
    // This should set off a cascade of changes. Make sure, first, that state has changed.
    state = JCImageGalleryViewStateGallery;
    currentState = self.imageGalleryViewController.state;
    STAssertEquals(state, currentState, @"State changed to gallery. Wanted: %d Got: %d", state, currentState);
    
    // Also check if the actual controller has changed
    JCViewController *currentController = self.imageGalleryViewController.currentViewController;
    JCGalleryViewController *gallery = self.galleryViewController;
    STAssertEqualObjects(currentController, gallery, @"State changed to gallery failed to change controller");
    
    // Make sure the amShowing property correctly changes
    amShowing = currentController.amShowing;
    STAssertTrue(amShowing, @"Current controller's amShowing wrong: %d", amShowing);
    amShowing = self.pinholeViewController.amShowing;
    STAssertFalse(amShowing, @"Pinhole amShowing wrong: %d", amShowing);
    amShowing = self.spotlightViewController.amShowing;
    STAssertFalse(amShowing, @"Spotlight amShowing wrong: %d", amShowing);
}

- (void)handleGesture
{
    NSLog(@"%@", self.name);

}

@end
