//
//  JCPinholeViewController.m
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCPinholeViewController.h"

@implementation JCPinholeViewController

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.delegate setState:JCImageGalleryViewStateSpotlight];
    
}

- (void)show
{
    CGRect newframe = [self.delegate.superview convertRect:self.delegate.frame toView:self.delegate.topView];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.delegate.view.frame = newframe;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [self.delegate.view removeFromSuperview];
                         self.delegate.view.frame = self.delegate.frame;
                         [self.delegate.superview addSubview:self.delegate.view];
                     }];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.delegate.view.backgroundColor = [UIColor grayColor];
                     }
                     completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO   
                                            withAnimation:UIStatusBarAnimationSlide];    
}


@end
