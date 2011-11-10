//
//  JCImageGalleryViewController.m
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCImageGalleryViewController.h"
#import "AppDelegate.h"

@implementation JCImageGalleryViewController

@synthesize superview = _mySuperview;
@synthesize view = _myView;
@synthesize frame = _frame;
@synthesize tap = _tap;
@synthesize images = _images;
@synthesize toolbar = _toolbar;
@synthesize done = _done;
@synthesize state = _state;
@synthesize topView = _topView;

- (id)initWithSuperview:(UIView *)superview
{
    return [self initWithSuperview:superview frame:superview.frame];
}

- (id)initWithSuperview:(UIView *)superview frame:(CGRect)frame
{
    self = [super init];
    
    if (self) {
        self.images = [[NSMutableArray alloc] initWithCapacity:4];

        self.topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
        
        self.frame = frame;
        self.view = [[UIScrollView alloc] initWithFrame:self.frame];
        [self.view setBackgroundColor: [UIColor grayColor]];


        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self.view addGestureRecognizer:self.tap];
        
        self.superview = superview;
        [self.superview addSubview:self.view];
        
        // We always begin in the pinhole state 
        // because we are initializing inside of a superview
        self.state = JCImageGalleryViewStatePinhole;
    }
    
    return self;    
}

- (void)handleDone:(id)sender
{
    [self.toolbar removeFromSuperview];
    [self.view addGestureRecognizer:self.tap];
    [self setState:JCImageGalleryViewStatePinhole];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setState:(JCImageGalleryViewState)state
{
    if (_state != state) {
        // Keep the old one just in case we have to revert it
        JCImageGalleryViewState oldState = _state;
        _state = state;
        
        switch (_state) {
            case JCImageGalleryViewStatePinhole:
                [self showPinholeView];
                break;
            case JCImageGalleryViewStateGallery:

                break;
            case JCImageGalleryViewStateSpotlight:
                [self showSpotlightView];
                break;
            default:
                // We encountered a state that we haven't accounted for, revert it and error
                _state = oldState;
                NSAssert(NO, @"Tried to switch to a state that doesn't exist: %d", state);
                break;
        }
    }
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    switch (self.state) {
        case JCImageGalleryViewStatePinhole:
            [self handlePinholeTap:gestureRecognizer];
            break;
        case JCImageGalleryViewStateSpotlight:
            [self handleSpotlightTap:gestureRecognizer];
            break;
        default:
            
            break;
    }
    
}


- (void)handlePinholeTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self setState:JCImageGalleryViewStateSpotlight];
}

- (void)handleSpotlightTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view removeGestureRecognizer:gestureRecognizer];
    [self showToolbar:self];
    
}

- (void)showPinholeView
{
    CGRect newframe = [self.superview convertRect:self.frame toView:self.topView];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.view.frame = newframe;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [self.view removeFromSuperview];
                         self.view.frame = self.frame;
                         [self.superview addSubview:self.view];
                     }];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.backgroundColor = [UIColor grayColor];
                     }
                     completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO   
                                            withAnimation:UIStatusBarAnimationSlide];
}

- (void)showSpotlightView
{
    [self.topView addSubview:self.view];
    self.view.frame = [self.topView convertRect:self.view.frame fromView:self.superview];
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.view.frame = self.topView.frame;
                     }
                     completion:^(BOOL finished){
                         [[UIApplication sharedApplication] setStatusBarHidden:YES   
                                                                 withAnimation:UIStatusBarAnimationSlide];
                     }];
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.backgroundColor = [UIColor blackColor];
                     }
                     completion:nil];    
}

- (void)showToolbar:(id)sender
{
    if (self.toolbar == nil) {
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.barStyle = UIBarStyleBlack;
        self.toolbar.translucent = YES;
        
        self.done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleDone:)];
        [self.done setEnabled:YES];
        
        self.toolbarItems = [NSArray arrayWithObject:self.done];
        [self.toolbar setItems:self.toolbarItems animated:YES];
        [self.toolbar sizeToFit];
    }
    
    [self.view addSubview:self.toolbar];
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
