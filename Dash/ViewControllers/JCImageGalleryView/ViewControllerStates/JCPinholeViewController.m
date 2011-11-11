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

@synthesize imageViewFrames = _imageViewFrames;

- (id)initWithContext:(id)context
{
    self = [super initWithContext:context];
    
    if (self) {
        self.imageViewFrames = [[NSMutableArray alloc] initWithCapacity:[self.context.imageViews count]];
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
        
        // Keep track of our rects
        [self.imageViewFrames addObject:[NSValue valueWithCGRect:imageFrame]];
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
    }
    
}

#pragma mark - Handling taps

- (CGFloat)distanceBetweenRect:(CGRect)rect andPoint:(CGPoint)point
{
    // first of all, we check if point is inside rect. If it is, distance is zero
    if (CGRectContainsPoint(rect, point)) return 0.f;
    
    // next we see which point in rect is closest to point
    CGPoint closest = rect.origin;
    if (rect.origin.x + rect.size.width < point.x)
        closest.x += rect.size.width; // point is far right of us
    else if (point.x > rect.origin.x) 
        closest.x = point.x; // point above or below us
    if (rect.origin.y + rect.size.height < point.y) 
        closest.y += rect.size.height; // point is far below us
    else if (point.y > rect.origin.y)
        closest.y = point.y; // point is straight left or right
    
    // we've got a closest point; now pythagorean theorem
    // distance^2 = [closest.x,y - closest.x,point.y]^2 + [closest.x,point.y - point.x,y]^2
    // i.e. [closest.y-point.y]^2 + [closest.x-point.x]^2
    CGFloat a = powf(closest.y-point.y, 2.f);
    CGFloat b = powf(closest.x-point.x, 2.f);
    return sqrtf(a + b);
}

/** If we tap the pinhole, we need to transform to the spotlight view and
    zoom in on the appropriate picture.
 */
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint loc = [gestureRecognizer locationInView:self.context.view];
    NSInteger offset;
    CGRect imageFrame;
    CGFloat delta = 0.0f;
    CGFloat minDelta = 1.0f;
    
    NSLog(@"heya %f %f", loc.x, loc.y);
    
    for (int i = 0; i < [self.imageViewFrames count]; ++i) {
        NSValue *val = [self.imageViewFrames objectAtIndex:i];
        imageFrame = [val CGRectValue];
        delta = [self distanceBetweenRect:imageFrame andPoint:loc];
        
        if (minDelta > delta) {
            minDelta = delta;
            offset = i;
        }
    }
    
    
    [self.context setState:JCImageGalleryViewStateSpotlight withOffset:offset];
}

#pragma mark - JCImageGalleryViewController

/** Returns to pinhole view, which is our initial frame assigned by the coder.
 */

- (void)show
{
    [self showOffset:0];
}

- (void)showOffset:(NSInteger)offset
{
    [self.context.view setScrollEnabled:NO];
    [self.context.view setPagingEnabled:NO];
    
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
    
    [self.context.view setContentSize:CGSizeZero];
}

- (void)hide
{
    
}

@end
