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
@synthesize imageViewFrames = _imageViewFrames;

#pragma mark - Some UI constants

static int kNumImagesPerRow = 4;
static CGFloat kStatusBarHeight = 20.0f;
static CGFloat kImageWidth = 70.0f;
static CGFloat kTopMargin = 64.0f;
static CGFloat kTopPadding = 6.0f; 
static CGFloat kLeftPadding = 8.0f;

#pragma mark - Class Methods

+ (CGFloat)xForColumn:(NSInteger)column withImageWidth:(CGFloat)imageWidth
{
    return kLeftPadding + (column * kLeftPadding) + (column * imageWidth);
}

+ (CGFloat)yForRow:(NSInteger)row withImageHeight:(CGFloat)imageHeight
{
    return ((row + 1) * kTopPadding) + (row * imageHeight);
}

+ (NSInteger)rowForIndex:(NSInteger)index
{
    return index / kNumImagesPerRow;
}

+ (NSInteger)columnForIndex:(NSInteger)index
{
    return index % kNumImagesPerRow;
}

+ (CGPoint)originForIndex:(NSInteger)index
{
    return [self originForIndex:index withOffset:0];
}

+ (CGPoint)originForIndex:(NSInteger)index withOffset:(NSInteger)offset
{
    CGFloat x = [self xForColumn:[self columnForIndex:index] withImageWidth:kImageWidth];
    CGFloat y = [self yForRow:[self rowForIndex:index] withImageHeight:kImageWidth];
    
    CGPoint origin = CGPointMake(x, y);
    
    return origin;
}

#pragma mark - Initialization

- (id)initWithContext:(id)delegate
{
    self = [super initWithContext:delegate];
    
    if (self) {
        // Let's make the toolbar
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.barStyle = UIBarStyleBlack;
        self.toolbar.translucent = YES;
        self.toolbar.frame = CGRectOffset(self.toolbar.frame, 0.0f, kStatusBarHeight);
        
        self.done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleDone:)];
        [self.done setEnabled:YES];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolbarItems = [NSArray arrayWithObjects:self.done, flexibleSpace, nil];
        [self.toolbar setItems:self.toolbarItems animated:YES];
        [self.toolbar sizeToFit];
        
        // Keep track of our image view frames for determining if one was tapped
        self.imageViewFrames = [[NSMutableArray alloc] initWithCapacity:[self.context.imageViews count]];
    }
    
    return self;
}

#pragma mark - Toolbar

- (void)handleDone:(id)sender
{
    [self.context setState:JCImageGalleryViewStatePinhole];
}

#pragma mark - Layout Helpers

- (void)prepareLayoutWithImageViews:(NSMutableArray *)imageViews offset:(NSInteger)offset
{
    UIImageView *imageView;
    CGRect rect;
    [self.imageViewFrames removeAllObjects];
    
    for (int i = 0; i < [imageViews count]; i++) {
        imageView = [imageViews objectAtIndex:i];
        
        rect = imageView.frame;
        rect.origin = [[self class] originForIndex:i withOffset:offset];
        imageView.frame = rect;
        
        // Keep track of our rects
        [self.imageViewFrames addObject:[NSValue valueWithCGRect:imageView.frame]];
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
        imageView.alpha = 1.0f;
    }
    
}

#pragma mark - JCImageGalleryController

/** Want to lay out the images side by side, one full screen per image
 */
- (void)layoutImageViews:(NSMutableArray *)imageViews inFrame:(CGRect)frame
{
    UIImageView *imageView;
    CGRect rect;
    [self.imageViewFrames removeAllObjects];
    
    for (int i = 0; i < [imageViews count]; i++) {
        imageView = [imageViews objectAtIndex:i];
        
        rect = imageView.frame;
        rect.origin = [[self class] originForIndex:i];
        rect = CGRectOffset(rect, 0.0f, kTopMargin);
        imageView.frame = rect;
        
        // Keep track of our rects
        [self.imageViewFrames addObject:[NSValue valueWithCGRect:imageView.frame]];
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
        imageView.alpha = 1.0f;
    }
}

/** If we tap the pinhole, we need to transform to the spotlight view and
 zoom in on the appropriate picture.
 */
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint loc = [gestureRecognizer locationInView:self.context.view];
    NSInteger offset = -1;
    CGRect imageFrame;
    
    // Figure out which image is closest to the point that was tapped
    for (int i = 0; i < [self.imageViewFrames count]; ++i) {
        NSValue *val = [self.imageViewFrames objectAtIndex:i];
        imageFrame = [val CGRectValue];
        if (CGRectContainsPoint(imageFrame, loc)) {
            offset = i;
        }
    }
    
    if (offset >= 0) {
        [self.context setState:JCImageGalleryViewStateSpotlight withOffset:offset];
    }
}

/** Takes over the full screen and hides the status bar.
 */
- (void)show
{
    [self showOffset:0];
}

- (void)showOffset:(NSInteger)offset
{
    [super showOffset:offset];
    
    // First step, if we are not on top, get on top  
    if (![self.context.topView.subviews containsObject:self.context.view]) {
        [self.context.topView addSubview:self.context.view];
        
        // Ok, now that we are in the top view, we want to appear the same 
        // as if nothing has changed, so we get the transform the frame's coordinates
        // and whatnot to the new view's system.
        self.context.view.frame = [self.context.topView convertRect:self.context.view.frame fromView:self.context.superview];
    }
    
    // Want to prepare the layout but putting all the images
    // that were arranged linearly into rows
    [self prepareLayoutWithImageViews:self.context.imageViews offset:offset];
    
    // So nothing has changed, in appearance to the user, but now we can start transforming.
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self layoutImageViews:self.context.imageViews inFrame:self.context.frame];
                     }
                     completion:nil];
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.context.view.frame = self.context.topView.frame;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.context.view.backgroundColor = [UIColor grayColor];
                     }
                     completion:nil];
    
    // Finally, handle the toolbar and status bar. They will always be showing.
    [self.context.topView addSubview:self.toolbar];   
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationNone];
}

- (void)hide
{
    [self hideOffset:0];
}

- (void)hideOffset:(NSInteger)offset
{
    [super hideOffset:offset];
    
    // Hide the toolbar when we are leaving this view.
    [self.toolbar removeFromSuperview];
    self.context.view.backgroundColor = [UIColor grayColor];
}

@end
