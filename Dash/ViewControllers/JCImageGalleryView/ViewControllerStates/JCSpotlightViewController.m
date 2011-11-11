//
//  JCSpotlightViewController.m
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCSpotlightViewController.h"

@implementation JCSpotlightViewController

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self toggleToolbar];
}

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
