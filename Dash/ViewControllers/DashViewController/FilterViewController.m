//
//  FilterView.m
//  Dash
//
//  Created by John Cadengo on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterViewController.h"
#import "Constants.h"

@implementation FilterViewController

enum {
    kCurrentLocationButtonIndex = 0,
    kCustomLocationButtonIndex = 1,
    kCancelButtonIndex = 2,
    kNumberActionSheetButtons = 3
};

enum {
    kSubmitCustomLocationButtonIndex = 0,
    kCancelCustomLocationButtonIndex = 1,
};

@synthesize filterView = _filterView;
@synthesize singleTap = _singleTap;
@synthesize locationButtonFrame = _locationButtonFrame;
@synthesize locationButton = _locationButton;
@synthesize changeLocationSheet = _changeLocationSheet;
@synthesize customLocationAlert = _customLocationAlert;
@synthesize customLocation = _customLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSLog(@"Filter view load view");
    
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    
    // The visible view at all times
    self.filterView = [[FilterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    self.filterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.filterView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add our tap gesture recognizer
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.filterView addGestureRecognizer:self.singleTap];
    [self.singleTap setDelegate:self];
    
    // Change the location button
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locationButton addTarget:self 
                            action:@selector(promptForLocation:) 
                  forControlEvents:UIControlEventTouchUpInside];
    [self.locationButton setTitle:@"  Current Location" forState:UIControlStateNormal];
    [self.locationButton.titleLabel setFont:[UIFont fontWithName:kHelveticaNeueBold size:14.0f]];
    [self.locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    
    [self.locationButton setBackgroundImage:[UIImage imageNamed:@"CurrentLocationButton"] forState:UIControlStateNormal];
    self.locationButtonFrame = CGRectMake(10.0f,265.0f, 300.0f, 50.0f);
    self.locationButton.frame = self.locationButtonFrame;
    [self.locationButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [self.filterView addSubview:self.locationButton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Location Button

- (void)promptForLocation:(id)sender
{
    if (self.changeLocationSheet == nil) {
        self.changeLocationSheet = [[UIActionSheet alloc] initWithTitle:@"Change Location" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Cancel" 
                                                 destructiveButtonTitle:nil 
                                                      otherButtonTitles:@"Current Location", @"Custom", nil];
        
    }
    
    [self.changeLocationSheet showInView:self.filterView];
    
}

- (void)useCurrentLocation
{
    self.customLocation = nil;
}

- (void)promptForCustomLocation
{
    if (self.customLocationAlert == nil) {
        self.customLocationAlert = [[UIAlertView alloc] initWithTitle:@"Custom Location" 
                                                              message:@"Enter an address or zip code below" 
                                                             delegate:self 
                                                    cancelButtonTitle:nil//@"Cancel" 
                                                    otherButtonTitles:@"Done", nil];
        [self.customLocationAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    }
    
    [self.customLocationAlert show];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    self.customLocation = [NSString stringWithFormat:@"%@", inputText];
    [self.locationButton setTitle:[NSString stringWithFormat:@"  Custom Location: %@", self.customLocation] forState:UIControlStateNormal];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.changeLocationSheet == actionSheet) {
        switch (buttonIndex) {
            case kCurrentLocationButtonIndex:
                self.customLocation = nil;
                [self.locationButton setTitle:[NSString stringWithFormat:@"  Current Location"] forState:UIControlStateNormal];
                break;
            case kCustomLocationButtonIndex:
                [self promptForCustomLocation];
                break;
            default:
                break;
        }
    }
}


#pragma mark - Handle state of filter view

- (void)invertTypeCheckedAtIndex:(NSInteger)i
{
    // Get current state
    NSNumber *state = [self.filterView.typesChecked objectAtIndex:i];
    
    // Invert it
    BOOL checked = [state boolValue] ? NO : YES;
 
    // Update current state
    [self.filterView.typesChecked replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:checked]];
}

- (void)invertPriceCheckedAtIndex:(NSInteger)i
{
    // Get current state
    NSNumber *state = [self.filterView.pricesChecked objectAtIndex:i];
    
    // Invert it
    BOOL checked = [state boolValue] ? NO : YES;
    
    // Update current state
    [self.filterView.pricesChecked replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:checked]];
}

- (void)setDistanceChecked:(DistanceFilter)i
{
    self.filterView.currentDistanceFilter = i;
}

#pragma mark - UIGestureRecognizer Delegate

/** Want certain events to pass right through
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint origin = [touch locationInView:self.view];
    BOOL insideLocationButton = CGRectContainsPoint(self.locationButtonFrame, origin);
    
    return (insideLocationButton) ? NO : YES;
}

#pragma mark - Tap gestures

- (NSInteger)indexOfFrames:(NSArray *)arr containPoint:(CGPoint)point
{
    // Figure out if any filter was tapped
    NSInteger indexTapped = -1;
    NSValue *value;
    CGRect frame;
    for (int i = 0; i < [arr count]; ++i) {
        value = [arr objectAtIndex:i];
        frame = [value CGRectValue];
        
        if (CGRectContainsPoint(frame, point)) {
            indexTapped = i;
            break;
        }
        
    }
    return indexTapped;
}

- (BOOL)handleTypesTapped:(CGPoint)origin
{
    NSInteger indexTapped = [self indexOfFrames:self.filterView.typesFrames containPoint:origin];
    
    if (indexTapped >= 0) {
        [self invertTypeCheckedAtIndex:indexTapped];
    }
    
    return (indexTapped >= 0) ? YES : NO;
}

- (BOOL)handlePricesTapped:(CGPoint)origin
{
    NSInteger indexTapped = [self indexOfFrames:self.filterView.pricesFrames containPoint:origin];
    
    if (indexTapped >= 0) {
        [self invertPriceCheckedAtIndex:indexTapped];
    }
    
    return (indexTapped >= 0) ? YES : NO;
}

- (BOOL)handleDistanceTapped:(CGPoint)origin
{
    NSInteger indexTapped = [self indexOfFrames:self.filterView.distancesFrames containPoint:origin];
 
    if (indexTapped >= 0) {
        [self setDistanceChecked:indexTapped];
    }
    
    return (indexTapped >= 0) ? YES : NO;
}

/** Receive touch events and respond accordingly.
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    // Find out where we tapped
    CGPoint tapPoint = [gestureRecognizer locationInView:self.filterView];
    //NSLog(@"tappoint: %f %f", tapPoint.x, tapPoint.y);
    
    // Check if any filters were tapped
    [self handleTypesTapped:tapPoint];
    [self handlePricesTapped:tapPoint];
    [self handleDistanceTapped:tapPoint];
    
    // Redraw view to match its new state
    [self.filterView setNeedsDisplay];
}

@end
