//
//  FilterView.m
//  Dash
//
//  Created by John Cadengo on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterViewController.h"

@implementation FilterViewController

@synthesize filterView = _filterView;
@synthesize singleTap = _singleTap;

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

- (void)checkDistance:(DistanceFilter)i
{
    NSLog(@"%d %d", self.filterView.currentDistanceFilter, i);
    self.filterView.currentDistanceFilter = i;
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
    NSInteger typeTapped = [self indexOfFrames:self.filterView.typesFrames containPoint:origin];
    
    if (typeTapped >= 0) {
        [self invertTypeCheckedAtIndex:typeTapped];
    }
    
    return (typeTapped >= 0) ? YES : NO;
}

- (BOOL)handlePricesTapped:(CGPoint)origin
{
    
}

- (BOOL)handleDistanceTapped:(CGPoint)origin
{
    NSInteger distanceTapped = [self indexOfFrames:self.filterView.distanceFrames containPoint:origin];
 
    if (distanceTapped >= 0) {
        [self checkDistance:distanceTapped];
    }
    
    return (distanceTapped >= 0) ? YES : NO;
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
