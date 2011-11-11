//
//  JCPinholeViewController.m
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCPinholeViewController.h"

#pragma mark - Some UI constants

static CGFloat kImageWidth = 70.0f;
static CGFloat kTopPadding = 5.0f;
static CGFloat kLeftPadding = 8.0f;

#pragma mark - Implementation

@implementation JCPinholeViewController

- (id)initWithContext:(id)context
{
    self = [super initWithContext:context];
    
    if (self) {
        [self layoutImageViews:self.context.imageViews inFrame:self.context.frame];
    }
    
    return self;
}

/** Pinhole view is the first view. So when we init, we also want to lay out the images.
 */
- (void)layoutImageViews:(NSMutableArray *)imageViews inFrame:(CGRect)frame 
{
    CGRect imageFrame;
    CGFloat totalWidth = frame.size.width;
    int numImagesPerRow = totalWidth / kImageWidth;
    int numImages = [imageViews count];
    
    // We only want to lay out one row
    int numImagesToLayout = MIN(numImagesPerRow, numImages);
    
    for (int i = 0; i < numImagesToLayout; i++) {
        UIImageView *imageView = [imageViews objectAtIndex:i];
        imageFrame = CGRectMake(((i + 1) * kLeftPadding) + (i * kImageWidth), kTopPadding, 
                                kImageWidth, kImageWidth);
        imageView.frame = imageFrame;
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
    }
    
}

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
    [self.context.view setScrollEnabled:NO];
    
    CGRect newframe = [self.context.superview convertRect:self.context.frame toView:self.context.topView];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self layoutImageViews:self.context.imageViews inFrame:newframe];
                     }
                     completion:nil];
    
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
