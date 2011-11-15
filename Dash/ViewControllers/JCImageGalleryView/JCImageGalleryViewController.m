//
//  JCImageGalleryViewController.m
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCImageGalleryViewController.h"
#import "JCViewController.h"
#import "JCPinholeViewController.h"
#import "JCGalleryViewController.h"
#import "JCSpotlightViewController.h"
#import "AppDelegate.h"

@implementation JCImageGalleryViewController

@synthesize state = _state;
@synthesize currentViewController = _currentViewController;
@synthesize pinholeViewController = _pinholeViewController;
@synthesize galleryViewController = _galleryViewController;
@synthesize spotlightViewController = _spotlightViewController;
@synthesize tap = _tap;

@synthesize topView = _topView;
@synthesize superview = _superview;
@synthesize view = _myView;
@synthesize frame = _frame;
@synthesize images = _images;
@synthesize imageViews = _imageViews;

- (id)initWithImages:(NSMutableArray *) images superview:(UIView *)superview
{
    return [self initWithImages:images superview:superview frame:superview.frame];
}

- (id)initWithImages:(NSMutableArray *) images superview:(UIView *)superview frame:(CGRect)frame
{
    self = [super init];
    
    if (self) {
        self.images = [[NSMutableArray alloc] initWithArray:images];
        self.imageViews = [[NSMutableArray alloc] initWithCapacity:[self.images count]];
        [self setImageViewsWithImages:self.images];
        
        self.topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
        
        self.frame = frame;
        self.view = [[UIScrollView alloc] initWithFrame:self.frame];
        [self.view setBackgroundColor: [UIColor grayColor]];
        
        self.superview = superview;
        [self.superview addSubview:self.view];
        
        //
        self.pinholeViewController = [[JCPinholeViewController alloc] initWithContext:self];
        self.galleryViewController = [[JCGalleryViewController alloc] initWithContext:self];
        self.spotlightViewController = [[JCSpotlightViewController alloc] initWithContext:self];
    
        self.currentViewController = self.pinholeViewController;
        [self.currentViewController show];
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self.view addGestureRecognizer:self.tap];
        [self.tap setDelegate:self];
    }
    
    return self;    
}

- (void)setImageViewsWithImages:(NSMutableArray *)images
{
    UIImageView *imageView;
    for (UIImage *image in images) {
        imageView = [[UIImageView alloc] initWithImage:image];
        [self.imageViews addObject:imageView];
    }
}

- (void)setState:(JCImageGalleryViewState)newState
{
    [self setState:newState withOffset:0];
}

- (void)setState:(JCImageGalleryViewState)newState withOffset:(NSInteger)offset
{
    if (_state != newState) {
        // Keep the old one just in case we have to revert it
        JCImageGalleryViewState oldState = _state;
        JCViewController *oldController = _currentViewController;
        _state = newState;
        
        switch (_state) {
            case JCImageGalleryViewStatePinhole:
                self.currentViewController = self.pinholeViewController;
                break;
            case JCImageGalleryViewStateGallery:
                self.currentViewController = self.galleryViewController;
                break;
            case JCImageGalleryViewStateSpotlight:
                self.currentViewController = self.spotlightViewController;
                break;
            default:
                // We encountered a state that we haven't accounted for, revert it and error
                _state = oldState;
                NSAssert(NO, @"Tried to switch to a state that doesn't exist: %d", newState);
                break;
        }
        
        [oldController hideOffset:offset];
        [self.currentViewController showOffset:offset];
    }
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.currentViewController handleGesture:gestureRecognizer];
}

#pragma mark - Gesture recognizer delegate methods

/** Lets touches on the toolbar pass through.
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view.superview isKindOfClass:[UIToolbar class]]) return NO;

    return YES;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Make sure we stop the animatiosn and whatnot that are ongoing
    [self.view removeFromSuperview];
    [self.superview addSubview: self.view];
    
    // TODO: Known bug where as we are transitioning, if the user changes the views
    // by pushing either another tab, or navigating back on the navigation controller
    // it will cause weird errors. Might want to intercept all touch events and disable them?
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
