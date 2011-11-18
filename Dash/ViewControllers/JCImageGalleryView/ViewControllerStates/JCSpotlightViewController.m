//
//  JCSpotlightViewController.m
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCSpotlightViewController.h"
#import "JCPinholeViewController.h"
#import "JCGalleryViewController.h"

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

static CGFloat kSmallImageTopPadding = 6.0f;
static CGFloat kSmallImageLeftPadding = 8.0f;

#pragma mark - Class methods

+ (CGPoint)originForOffset:(NSInteger)newOffset
{
    CGFloat x = kImageWidth * newOffset;
    CGFloat y = 0.0f;
    
    CGPoint origin = CGPointMake(x, y);
    
    return origin;
}

+ (NSInteger)offsetForOrigin:(CGPoint)origin
{
    CGFloat x = origin.x;
    
    return x / kImageWidth;
}

+ (CGPoint)originForRow:(NSInteger)row column:(NSInteger)column
{
    CGFloat x = column * (kImageWidth);
    CGFloat y = ((row + 1) * kTopPadding) + (row * kImageWidth);
    
    CGPoint origin = CGPointMake(x, y);
    
    return origin;
}

+ (CGPoint)contentViewOffsetForRow:(NSInteger)row column:(NSInteger)column
{
    CGFloat x = column * (kImageWidth);
    CGFloat y = (row * kTopPadding) + (row * kImageWidth);
    
    CGPoint origin = CGPointMake(x, y);
    
    return origin;    
}

+ (CGSize)contentSizeForNumImages:(NSInteger)numImages
{
    return CGSizeMake(kImageWidth * numImages, kImageWidth);
}

+ (CGSize)contentSizeInRowsForNumImages:(NSInteger)numImages
{
    int row = [JCGalleryViewController rowForIndex:numImages - 1];
    
    return CGSizeMake(kImageWidth * 4, ((row + 2) * kTopPadding) + ((row + 1) * kImageWidth));
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
    NSInteger offset = [[self class] offsetForOrigin:self.context.view.contentOffset];
    [self.context setState:JCImageGalleryViewStatePinhole withOffset:offset];
}

- (void)handleSeeAll:(id)sender
{
    NSInteger offset = [[self class] offsetForOrigin:self.context.view.contentOffset];
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

- (void)willLayoutWithOffset:(NSInteger)offset
{
    // PAGING WAS GETTING IN THE WAY OF SETTING THE CONTENT VIEW OFFSET!
    [self.context.view setScrollEnabled:NO];
    [self.context.view setPagingEnabled:NO];
    
    // Update the content size to accomdate our new larger images

    
    // How to prepare? Scale? Layout?
}

/** Want to lay out the images side by side, one full screen per image
 */
- (void)layoutWithOffset:(NSInteger)offset
{
    UIImageView *imageView;
    CGRect rect;
    CGSize size;    
    CGPoint origin;
    
    NSLog(@"size %f %f", self.context.view.contentSize.width, self.context.view.contentSize.height);
    
    // We need to be able to tell if we're coming from gallery view, 
    // if things are layed out in rows.
    imageView = [self.context.imageViews lastObject];
    BOOL inRows = (imageView.frame.origin.y > 6.0f) ? YES : NO;
    
    // We only have to do this if we aren't already the topview frame.
    if (!inRows) {
        self.context.view.frame = self.context.topView.frame;
        
        //CGPoint offsetPoint = CGPointMake(offset * kImageWidth, 0);
       //[self.context.view setContentOffset:offsetPoint];
        
    }
    else {
        // Make sure we are looking at the same current image
        // to maintain the illusion that nothing has changed
        self.context.view.contentSize = [[self class] contentSizeInRowsForNumImages:[self.context.imageViews count]];
        
        int offRow = [JCGalleryViewController rowForIndex:offset];
        int offColumn = [JCGalleryViewController columnForIndex:offset];
        
        CGPoint curImageNewOrigin = [[self class] contentViewOffsetForRow:offRow column:offColumn];
        [self.context.view setContentOffset:curImageNewOrigin];
        
        NSLog(@"row %d col %d offset %d %f %f", offRow, offColumn, offset, curImageNewOrigin.x, curImageNewOrigin.y);
    }
    
    for (int i = 0; i < [self.context.imageViews count]; i++) {
        imageView = [self.context.imageViews objectAtIndex:i];
  
        // Get the old frame
        rect = imageView.frame;
        
        // Now scale its size
        size = CGSizeMake(kImageWidth, kImageWidth);
        rect.size = size;
        
        // Get the old origin
        origin = rect.origin;
        
        // Now adjust it to account for the increased image size
        if (inRows) {
            NSLog(@"in rows");
            
            int row = [JCGalleryViewController rowForIndex:i];
            int column = [JCGalleryViewController columnForIndex:i];
            
            origin = [[self class] originForRow:row column:column];
            
            NSLog(@"i %d origin %f %f size %f %f", i, origin.x, origin.y, size.width, size.height);
        }
        else {
            NSLog(@"not in rows");
            origin = CGPointMake((i * kImageWidth), kTopPadding);
        }
        
        // Now update the frame
        rect.origin = origin;   
        imageView.frame = rect;
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
    }
    

}

- (void)didLayoutWithOffset:(NSInteger)offset
{
    CGRect imageFrame;
    UIImageView *imageView;
    
    [self.context.view setScrollEnabled:YES];
    [self.context.view setPagingEnabled:YES];
    
    self.context.view.contentSize = [[self class] contentSizeForNumImages:[self.context.imageViews count]];
    
    for (int i = 0; i < [self.context.imageViews count]; i++) {
        imageView = [self.context.imageViews objectAtIndex:i];
        imageFrame = CGRectMake((i * kImageWidth), kTopPadding, 
                                kImageWidth, kImageWidth);
        imageView.frame = imageFrame;
        
        // Add this imageview to our view
        [self.context.view addSubview:imageView];
        //imageView.alpha = 1.0f;
    }
    CGPoint offsetPoint = CGPointMake(offset * kImageWidth, 0);
    [self.context.view setContentOffset:offsetPoint];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES   
                                            withAnimation:UIStatusBarAnimationSlide];
}

/** If we tap the spotlight view we need to toggle the toolbars.
 */
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [self toggleToolbar];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    // Make sure that we send the right offset as we transition.
    NSInteger offset = [[self class] offsetForOrigin:self.context.view.contentOffset];
    [self.context setState:JCImageGalleryViewStateGallery withOffset:offset];
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
    
    BOOL inRows = YES;
    
    if (![self.context.topView.subviews containsObject:self.context.view]) {
        [self.context.topView addSubview:self.context.view];
        
        self.context.view.frame = [self.context.topView convertRect:self.context.view.frame fromView:self.context.superview];
        
        inRows = NO;
    }
    
    [self willLayoutWithOffset:offset];
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self layoutWithOffset:offset];
                     }
                     completion:^(BOOL finished) {
                         [self didLayoutWithOffset:offset];
                     }];
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.context.view.backgroundColor = [UIColor blackColor];
                     }
                     completion:nil];    
    
    if (!inRows) {
        CGPoint offsetPoint = CGPointMake(offset * kImageWidth, 0);
        [self.context.view setContentOffset:offsetPoint];
    }
}

- (void)hide
{
    [self hideOffset:0];
}

- (void)hideOffset:(NSInteger)offset
{
    [super hideOffset:offset];
    
    // Hide the toolbar when we are leaving this view.
    // TODO: For some reason we need to "reset" the toolbar if we transition
    // from spotlight to gallery through the longPress gesture while the toolbar is hidden.
    [self setToolbarVisible:YES];
    [self setToolbarVisible:NO];
        
    // Go back to the first page, which is page 0
    //[self.context.view setContentOffset:[self originForPage:0] animated:NO];
}


@end
