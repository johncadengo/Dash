//
//  JCViewController.m
//  
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCViewController.h"

@implementation JCViewController

@synthesize context = _context;
@synthesize showing = _showing;

- (id)init
{
    NSAssert(NO, @"Must initialize a JCViewController with a context.");
    return nil;
}

- (id)initWithContext:(id)context;
{
    self = [super init];
    
    if (self) {
        self.context = context;
        [self setShowing:NO];
    }
    
    return self;
}

/** Pinhole view is the first view. So when we init, we also want to lay out the images.
 */
- (void)layoutImageViews:(NSMutableArray *)imageViews inFrame:(CGRect)frame 
{

}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    // Subclasses must implement this
}

- (void)show
{
    [self setShowing:YES];
}

- (void)showOffset:(NSInteger)offset
{
    [self setShowing:YES];
}

- (void)hide
{
    [self setShowing:NO];
}

- (void)hideOffset:(NSInteger)offset
{
    [self setShowing:NO];
}

@end
