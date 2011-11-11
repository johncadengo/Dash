//
//  JCPinholeViewController.m
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCPinholeViewController.h"

@implementation JCPinholeViewController


/** If we tap the pinhole, we need to transform to the spotlight view and
    zoom in on the appropriate picture.
 */
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.context setState:JCImageGalleryViewStateSpotlight];
    
}

/** Returns to pinhole view, which is our initial frame assigned by the coder.
 */
- (void)show
{
    CGRect newframe = [self.context.superview convertRect:self.context.frame toView:self.context.topView];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.context.view.frame = newframe;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [self.context.view removeFromSuperview];
                         self.context.view.frame = self.context.frame;
                         [self.context.superview addSubview:self.context.view];
                     }];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.context.view.backgroundColor = [UIColor grayColor];
                     }
                     completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO   
                                            withAnimation:UIStatusBarAnimationSlide];    
}

- (void)hide
{
    
}

@end
