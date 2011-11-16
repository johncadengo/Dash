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
static int kNumImagesPerRow = 4;

#pragma mark - Implementation

@implementation JCPinholeViewController

@synthesize imageViewFrames = _imageViewFrames;

#pragma mark - Class methods

+ (CGFloat)xForImageIndex:(NSInteger)index
{
    // Every 4 images add extra padding
    CGFloat extraPadding = (index / kNumImagesPerRow) * kLeftPadding;
    return ((index + 1) * kLeftPadding) + (index * kImageWidth) + extraPadding;
}

+ (CGFloat)yForImageIndex:(NSInteger)index
{
    return kTopPadding;
}

+ (CGPoint)originForImageIndex:(NSInteger)index
{
    return CGPointMake([self xForImageIndex:index], [self yForImageIndex:index]);
}

+ (CGSize)contentSizeForNumImages:(NSInteger)numImages
{
    // To round up: q = (x + y - 1) / y;
    int numPages = (numImages + kNumImagesPerRow - 1) / kNumImagesPerRow;
    CGFloat width = numPages * 320.0f;
    CGFloat height = kImageWidth + (2 * kTopPadding);
    return CGSizeMake(width, height);
}

+ (NSInteger)pageForOffset:(NSInteger)offset
{   
    return offset / kNumImagesPerRow;
}

+ (NSInteger)pageForOrigin:(CGPoint)origin
{
    return floor(origin.x / 320.0f);
}

+ (CGPoint)originForPage:(NSInteger)page
{
    return CGPointMake(320.0f * page, 0.0f);
}

#pragma mark - Initialization

- (id)initWithContext:(id)context
{
    self = [super initWithContext:context];
    
    if (self) {
        self.imageViewFrames = [[NSMutableArray alloc] initWithCapacity:[self.context.imageViews count]];
    }
    
    return self;
}

- (void)prepareLayoutWithImageViews:(NSMutableArray *)imageViews offset:(NSInteger)offset
{
    [self.context.view setScrollEnabled:YES];
    [self.context.view setPagingEnabled:YES];
    
    self.context.view.contentSize = [[self class] contentSizeForNumImages:[imageViews count]];
    
    // So, depending on what offset we are, we need to first
    // figure out the page that image is indexed at
    NSInteger page = [[self class] pageForOffset:offset];
    
    // Then, we need to set the contentoffset to the CGPoint origin of that page.
    CGPoint pageOrigin = [[self class] originForPage:page];
    [self.context.view setContentOffset:pageOrigin];
}

- (void)setContentView
{
    
}

- (void)setContentOffset:(NSInteger)offset
{
    
}

/** Pinhole view is the first view. So when we init, we also want to lay out the images.
 */
- (void)layoutImageViews:(NSMutableArray *)imageViews inFrame:(CGRect)frame 
{
    CGRect imageFrame;
    int numImages = [imageViews count];
    
    [self.imageViewFrames removeAllObjects];
    
    // We only want to lay out one row
    //int numImagesToLayout = MIN(numImagesPerRow, numImages);
    
    for (int i = 0; i < numImages; i++) {
        UIImageView *imageView = [imageViews objectAtIndex:i];
        imageFrame = CGRectMake([[self class] xForImageIndex:i], kTopPadding, 
                                kImageWidth, kImageWidth);
        imageView.frame = imageFrame;
        
        // Keep track of our rects
        [self.imageViewFrames addObject:[NSValue valueWithCGRect:imageFrame]];
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
    }
    
}

#pragma mark - Handling taps

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

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    [self.context setState:JCImageGalleryViewStateGallery];
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
    [super showOffset:offset];
    
    // Only do the animation if we are in the topview. i.e. not in our superview.
    if ([[self.context.topView subviews] containsObject:self.context.view]) {
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
    else {
        [self layoutImageViews:self.context.imageViews inFrame:self.context.frame];
    }
    
    [self prepareLayoutWithImageViews:self.context.imageViews offset:offset];
}

- (void)hide
{
    [self hideOffset:0];
}

- (void)hideOffset:(NSInteger)offset
{
    [super hideOffset:offset];
}

@end
