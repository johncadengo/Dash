//
//  JCGalleryViewController.m
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCGalleryViewController.h"

@implementation JCGalleryViewController

@synthesize toolbar = _toolbar;
@synthesize done = _done;

#pragma mark - Init

- (id)initWithContext:(id)delegate
{
    self = [super initWithContext:delegate];
    
    if (self) {
        // Let's make the toolbar
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.barStyle = UIBarStyleBlack;
        self.toolbar.translucent = YES;
        
        self.done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleDone:)];
        [self.done setEnabled:YES];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolbarItems = [NSArray arrayWithObjects:self.done, flexibleSpace, nil];
        [self.toolbar setItems:self.toolbarItems animated:YES];
        [self.toolbar sizeToFit];
    }
    
    return self;
}

#pragma mark - Toolbar

- (void)handleDone:(id)sender
{
    [self.context setState:JCImageGalleryViewStatePinhole];
}

#pragma mark - JCImageGalleryController

/** If we tap the spotlight view we need to toggle the toolbars.
 */
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.context setState:JCImageGalleryViewStateSpotlight];
}

/** Takes over the full screen and hides the status bar.
 */
- (void)show
{    
    [self.context.view addSubview:self.toolbar];

    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                        self.context.view.backgroundColor = [UIColor grayColor];
                     }
                     completion:nil];
}

- (void)hide
{
    // Hide the toolbar when we are leaving this view.
    [self.toolbar removeFromSuperview];
    self.context.view.backgroundColor = [UIColor grayColor];
}

@end
