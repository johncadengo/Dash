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

- (void)setContentView
{
    [self.context.view setScrollEnabled:YES];
    [self.context.view setPagingEnabled:YES];
    
    self.context.view.contentSize = [[self class] contentSizeForNumImages:[self.context.imageViews count]];
}

- (void)setContentOffset:(NSInteger)offset
{
    // So, depending on what offset we are, we need to first
    // figure out the page that image is indexed at
    NSInteger page = [[self class] pageForOffset:offset];
    
    // Then, we need to set the contentoffset to the CGPoint origin of that page.
    CGPoint pageOrigin = [[self class] originForPage:page];
    [self.context.view setContentOffset:pageOrigin];
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
    CGFloat minDelta = kLeftPadding / 2.0f;    // Initial error of margin?
    
    // Figure out which image is closest to the point that was tapped
    for (int i = 0; i < [self.imageViewFrames count]; ++i) {
        NSValue *val = [self.imageViewFrames objectAtIndex:i];
        imageFrame = [val CGRectValue];
        delta = [self distanceBetweenRect:imageFrame andPoint:loc];
        
        if (delta < minDelta) {
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
        

        
        NSLog(@"%f", self.context.view.contentSize.width);
    }
    else {
        [self layoutImageViews:self.context.imageViews inFrame:self.context.frame];
    }
    
    [self setContentView];
    [self setContentOffset:offset];
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
