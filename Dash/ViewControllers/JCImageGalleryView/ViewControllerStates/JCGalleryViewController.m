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

static CGFloat kStatusBarHeight = 20.0f;
static CGFloat kImageWidth = 70.0f;
static CGFloat kTopMargin = 64.0f;
static CGFloat kTopPadding = 6.0f; 
static CGFloat kLeftPadding = 8.0f;

#pragma mark - Implementation

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

#pragma mark - JCImageGalleryController

/** Want to lay out the images side by side, one full screen per image
 */
- (void)layoutImageViews:(NSMutableArray *)imageViews inFrame:(CGRect)frame 
{
    CGRect imageFrame;
    CGFloat totalWidth = frame.size.width;
    int numImagesPerRow = totalWidth / kImageWidth;
    int numImages = [imageViews count];
    UIImageView *imageView;
    
    int row;
    int column;
    
    for (int i = 0; i < numImages; i++) {
        imageView = [imageViews objectAtIndex:i];
        
        column = i % numImagesPerRow;
        row = i / numImagesPerRow;
        
        imageFrame = CGRectMake(kLeftPadding + (column * kLeftPadding) + (column * kImageWidth),
                                kTopMargin + (row * kTopPadding) + (row * kImageWidth), 
                                kImageWidth, kImageWidth);
        imageView.frame = imageFrame;
        
        // Keep track of our rects
        [self.imageViewFrames addObject:[NSValue valueWithCGRect:imageFrame]];
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
    }
    
}

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
    [self showOffset:0];
}

- (void)showOffset:(NSInteger)offset
{
    if (![self.context.topView.subviews containsObject:self.context.view]) {
        [self.context.topView addSubview:self.context.view];
        
        self.context.view.frame = [self.context.topView convertRect:self.context.view.frame fromView:self.context.superview];
    }
    
    // In gallery view the toolbar will always be showing
    [self.context.topView addSubview:self.toolbar];   
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationNone];
    
    [self.context.view setScrollEnabled:YES];
    [self.context.view setPagingEnabled:NO];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.context.view.backgroundColor = [UIColor grayColor];
                     }
                     completion:nil];
    
    CGSize contentSize = CGSizeMake(kImageWidth * [self.context.imageViews count], kImageWidth);
    self.context.view.contentSize = contentSize;
    
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
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.context.view.backgroundColor = [UIColor blackColor];
                     }
                     completion:nil];    
    
    NSLog(@"offset %d", offset);
    CGPoint offsetPoint = CGPointMake(offset * kImageWidth, 0);
    [self.context.view setContentOffset:offsetPoint];
}

- (void)hide
{
    // Hide the toolbar when we are leaving this view.
    [self.toolbar removeFromSuperview];
    self.context.view.backgroundColor = [UIColor grayColor];
}

@end
