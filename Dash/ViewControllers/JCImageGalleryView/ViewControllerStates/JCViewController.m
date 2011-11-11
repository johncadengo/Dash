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
    // Subclasses must implement this    
}

- (void)hide
{
    // Subclasses must implement this
}


@end
