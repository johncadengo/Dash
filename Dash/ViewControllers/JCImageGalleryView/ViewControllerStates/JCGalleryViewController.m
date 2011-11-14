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

#pragma mark - Layout Helpers

- (CGFloat)xForColumn:(NSInteger)column withImageWidth:(CGFloat)imageWidth
{
    return kLeftPadding + (column * kLeftPadding) + (column * imageWidth);
}

- (CGFloat)yForRow:(NSInteger)row withImageHeight:(CGFloat)imageHeight
{
    return kTopMargin + (row * kTopPadding) + (row * imageHeight);
}

- (void)prepareLayoutWithImageViews:(NSMutableArray *)imageViews
{
    UIImageView *imageView;
    int row;
    int column;
    
    CGFloat imageWidth = 320.0f;
    CGFloat imageHeight = imageWidth;
    
    // Skip the first?
    for (int i = 1; i < [imageViews count]; i++) {
        imageView = [imageViews objectAtIndex:i];
        
        column = i % kNumImagesPerRow;
        row = i / kNumImagesPerRow;
        
        imageView.frame = CGRectMake([self xForColumn:column withImageWidth:imageWidth], 
                                     [self yForRow:row withImageHeight:imageHeight] + 80.0f, 
                                     imageWidth, imageHeight);
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
    }
}

#pragma mark - JCImageGalleryController

/** Want to lay out the images side by side, one full screen per image
 */
- (void)layoutImageViews:(NSMutableArray *)imageViews inFrame:(CGRect)frame
{
    UIImageView *imageView;
    int row;
    int column;
    
    CGFloat imageWidth = 70.0f;
    CGFloat imageHeight = imageWidth;
    
    for (int i = 0; i < [imageViews count]; i++) {
        imageView = [imageViews objectAtIndex:i];
        
        column = i % kNumImagesPerRow;
        row = i / kNumImagesPerRow;
        
        imageView.frame = CGRectMake([self xForColumn:column withImageWidth:imageWidth], 
                                     [self yForRow:row withImageHeight:imageHeight], 
                                     imageWidth, imageHeight);
        
        // Keep track of our rects
        [self.imageViewFrames addObject:[NSValue valueWithCGRect:imageView.frame]];
        
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
    NSLog(@"gallery offset: %d", offset);
    
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
    
    CGFloat width = self.context.view.frame.size.width;
    
    int numRows = [self.context.imageViews count] / kNumImagesPerRow;
    // Just a little bigger than the screen size so that we give 
    // the illusion of scrolling even when we don't need to scroll
    CGFloat height = MAX([self yForRow:numRows+1 withImageHeight:70.0f], 481.0f);
    CGSize contentSize = CGSizeMake(width, height);
    self.context.view.contentSize = contentSize;
    
    [self prepareLayoutWithImageViews:self.context.imageViews];
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self layoutImageViews:self.context.imageViews inFrame:self.context.view.frame];
                     }
                     completion:nil];
    
    [UIView animateWithDuration:1.0
                          delay:0.5
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
