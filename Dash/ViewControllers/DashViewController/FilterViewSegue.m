//
//  FilterViewSegue.m
//  Dash
//
//  Created by John Cadengo on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterViewSegue.h"
#import "DashViewController.h"
#import "FilterViewController.h"
#import "FilterView.h"

@implementation FilterViewSegue

- (void)perform
{
    // Get the source and destination view controllers
    DashViewController *dashViewController = (DashViewController *) self.sourceViewController;
    FilterViewController *filterViewController = (FilterViewController *) self.destinationViewController;
    
    // Make sure we are connected
    if (dashViewController.filterView == nil) {
        dashViewController.filterViewController = filterViewController;
        dashViewController.filterView = filterViewController.view;
    }
    
    [dashViewController.view addSubview:dashViewController.filterView];
    
    /*
     CGRect filterFrame = CGRectMake(0.0f, 0.0f, 320.0f, 304.0f);
     self.filterView = [[FilterView alloc] initWithFrame:filterFrame];
     [self.filterView setBackgroundColor:[UIColor blackColor]];
     [dragSuperView addSubview:self.filterView];
     
     // Make sure it is on top
     [dragSuperView bringSubviewToFront:self.filterView];
     */
    
    
    
}

@end
