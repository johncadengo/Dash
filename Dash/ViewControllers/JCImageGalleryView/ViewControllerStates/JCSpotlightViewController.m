//
//  JCSpotlightViewController.m
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCSpotlightViewController.h"
#import "JCPinholeViewController.h"

@implementation JCSpotlightViewController

@synthesize toolbar = _toolbar;
@synthesize toolbarVisible = _toolbarVisible;
@synthesize done = _done;
@synthesize seeAll = _seeAll;

#pragma mark - Some UI constants

static CGFloat kImageWidth = 320.0f;
static CGFloat kTopPadding = 80.0f;
static CGFloat kLeftPadding = 0.0f;
static CGFloat kStatusBarHeight = 20.0f;

#pragma mark - Class methods

+ (CGPoint)originForPage:(NSInteger)newPage
{
    CGFloat x = kImageWidth * newPage;
    CGFloat y = 0.0f;
    
    CGPoint origin = CGPointMake(x, y);
    
    return origin;
}

+ (NSInteger)pageForOrigin:(CGPoint)origin
{
    CGFloat x = origin.x;
    
    return x / kImageWidth;
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
        
        self.seeAll = [[UIBarButtonItem alloc] initWithTitle:@"See All" style:UIBarButtonItemStyleBordered target:self action:@selector(handleSeeAll:)];
        [self.seeAll setEnabled:YES];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolbarItems = [NSArray arrayWithObjects:self.done, flexibleSpace, self.seeAll, nil];
        [self.toolbar setItems:self.toolbarItems animated:YES];
        [self.toolbar sizeToFit];
    }
    
    return self;
}

#pragma mark - Toolbar

- (void)handleDone:(id)sender
{
    NSInteger offset = [[self class] pageForOrigin:self.context.view.contentOffset];
    [self.context setState:JCImageGalleryViewStatePinhole withOffset:offset];
}

- (void)handleSeeAll:(id)sender
{
    NSInteger offset = [[self class] pageForOrigin:self.context.view.contentOffset];
    [self.context setState:JCImageGalleryViewStateGallery withOffset:offset];
}

- (void)setToolbarVisible:(BOOL)toolbarVisible
{
    if (self.toolbarVisible) {
        // If it is already visible, remove it
        [self.toolbar removeFromSuperview];
    }
    else {
        // Otherwise, add it
        [self.context.topView addSubview:self.toolbar];        
    }
    
    // Now set the BOOL to reflect the changes
    _toolbarVisible = toolbarVisible;
}

- (void)toggleToolbar
{
    self.isToolbarVisible ? [self setToolbarVisible:NO] : [self setToolbarVisible:YES];
    
    // Pair this with showing the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:!self.isToolbarVisible
                                            withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - JCImageGalleryController

- (void)willLayoutImageViews:(NSMutableArray *)imageViews withOffset:(NSInteger)offset
{
    CGRect imageFrame;
    UIImageView *imageView;
    
    int firstRow =  offset + 4;
    
    for (int i = 0; i < [imageViews count]; i++) {
        imageView = [self.context.imageViews objectAtIndex:i];
        if (i < firstRow) {
            imageFrame = CGRectMake((i * kImageWidth), kTopPadding, 
                                    kImageWidth, kImageWidth);
            imageView.frame = imageFrame;
            
            // Add this imageview to our view
            [self.context.view addSubview:imageView];
            //imageView.alpha = 1.0f;
        }
        else {
            [imageView removeFromSuperview];
        }
    }
}

/** Want to lay out the images side by side, one full screen per image
 */
- (void)layoutImageViews:(NSMutableArray *)imageViews withOffset:(NSInteger)offset
{
    CGRect imageFrame;
    UIImageView *imageView;
    
    for (int i = 0; i < [imageViews count]; i++) {
        imageView = [self.context.imageViews objectAtIndex:i];
        imageFrame = CGRectMake((i * kImageWidth), kTopPadding, 
                                kImageWidth, kImageWidth);
        imageView.frame = imageFrame;
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
        //imageView.alpha = 1.0f;
    }
}

- (void)didLayoutImageViews:(NSMutableArray *)imageViews withOffset:(NSInteger)offset
{
    
}

/** If we tap the spotlight view we need to toggle the toolbars.
 */
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [self toggleToolbar];
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
    if (![self.context.topView.subviews containsObject:self.context.view]) {
        [self.context.topView addSubview:self.context.view];
        
        self.context.view.frame = [self.context.topView convertRect:self.context.view.frame fromView:self.context.superview];
    }
 
    [self.context.view setScrollEnabled:YES];
    [self.context.view setPagingEnabled:YES];
    
    CGSize contentSize = CGSizeMake(kImageWidth * [self.context.imageViews count], kImageWidth);
    self.context.view.contentSize = contentSize;
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self willLayoutImageViews:self.context.imageViews withOffset:offset];
                     }
                     completion:^(BOOL finished) {
                         [self layoutImageViews:self.context.imageViews withOffset:offset];
                     }];
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.context.view.frame = self.context.topView.frame;
                     }
                     completion:^(BOOL finished){
                         [[UIApplication sharedApplication] setStatusBarHidden:YES   
                                                                 withAnimation:UIStatusBarAnimationSlide];
                     }];
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.context.view.backgroundColor = [UIColor blackColor];
                     }
                     completion:nil];    
    
    CGPoint offsetPoint = CGPointMake(offset * kImageWidth, 0);
    [self.context.view setContentOffset:offsetPoint];
}

- (void)hide
{
    [self hideOffset:0];
}

- (void)hideOffset:(NSInteger)offset
{
    [super hideOffset:offset];
    
    // Hide the toolbar when we are leaving this view.
    [self setToolbarVisible:NO];
    
    // Go back to the first page, which is page 0
    //[self.context.view setContentOffset:[self originForPage:0] animated:NO];
}


@end
