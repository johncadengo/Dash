//
//  JCSpotlightViewController.m
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCSpotlightViewController.h"

@implementation JCSpotlightViewController

@synthesize toolbar = _toolbar;
@synthesize toolbarVisible = _toolbarVisible;
@synthesize done = _done;

#pragma mark - Init

- (id)initWithDelegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    
    if (self) {
        // Let's make the toolbar
        self.toolbarVisible = NO;
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.barStyle = UIBarStyleBlack;
        self.toolbar.translucent = YES;
        
        self.done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleDone:)];
        [self.done setEnabled:YES];
        
        self.toolbarItems = [NSArray arrayWithObject:self.done];
        [self.toolbar setItems:self.toolbarItems animated:YES];
        [self.toolbar sizeToFit];
    }
    
    return self;
}

#pragma mark - Toolbar

- (void)handleDone:(id)sender
{
    [self setToolbarVisible:NO];
    [self.delegate setState:JCImageGalleryViewStatePinhole];
}

- (void)setToolbarVisible:(BOOL)toolbarVisible
{
    if (self.toolbarVisible) {
        // If it is already visible, remove it
        [self.toolbar removeFromSuperview];
    }
    else {
        // Otherwise, add it
        [self.delegate.view addSubview:self.toolbar];        
    }
    
    // Now set the BOOL to reflect the changes
    _toolbarVisible = toolbarVisible;
}

- (void)toggleToolbar
{
    self.isToolbarVisible ? [self setToolbarVisible:NO] : [self setToolbarVisible:YES];
}

#pragma mark - JCImageGalleryController

/** If we tap the spotlight view we need to toggle the toolbars.
 */
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self toggleToolbar];
}

/** Takes over the full screen and hides the status bar.
 */
- (void)show
{
    [self.delegate.topView addSubview:self.delegate.view];
    self.delegate.view.frame = [self.delegate.topView convertRect:self.delegate.view.frame fromView:self.delegate.superview];
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.delegate.view.frame = self.delegate.topView.frame;
                     }
                     completion:^(BOOL finished){
                         [[UIApplication sharedApplication] setStatusBarHidden:YES   
                                                                 withAnimation:UIStatusBarAnimationSlide];
                     }];
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.delegate.view.backgroundColor = [UIColor blackColor];
                     }
                     completion:nil];    

}

@end
