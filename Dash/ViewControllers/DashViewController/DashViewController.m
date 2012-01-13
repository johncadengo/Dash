//
//  DashViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashViewController.h"
#import "DashAPI.h"
#import "Place.h"
#import "PlaceSquareView.h"
#import "Constants.h"
#import "PlaceViewController.h"
#import "JCLocationManagerSingleton.h"
#import "FilterView.h"

@implementation DashViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize locationManager = _locationManager;
@synthesize places = _places;

@synthesize loading = _loading;
@synthesize dragging = _dragging;
@synthesize currentPage = _currentPage;

@synthesize popsScrollView = _popsScrollView;
@synthesize progressHUD = _progressHUD;
@synthesize label = _label;
@synthesize popButton = _popButton;
@synthesize filterView = _filterView;
@synthesize singleTap = _singleTap;
@synthesize drag = _drag;

@synthesize quadrantCells = _quadrants;
@synthesize quadrantFrames = _quadrantFrames;

#pragma mark - UI Constants
enum {
    kPrePopPage = -1,
    kPlacesPerPage = 4
};

#pragma mark - Class methods for determining layout

/** There are four places per page.
 */
+ (NSInteger)pageForIndex:(NSInteger) index
{
    NSInteger page;
    
    // Calculate page if it is greater than or equal to zero
    // But otherwise, we are at the PrePopPage
    page = (index >= 0) ? (index / kPlacesPerPage) : kPrePopPage;
    
    return page;
}

+ (NSInteger)firstIndexForPage:(NSInteger) page
{
    NSInteger index;
    
    //
    index = (page >= 0) ? (page * kPlacesPerPage) : kPrePopPage;
    
    return index;
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];  
    
    // Initialize some things
    self.loading = NO;
    self.dragging = NO;
    self.currentPage = kPrePopPage; // -1
    self.places = [[NSMutableArray alloc] initWithCapacity:12];
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Add our pops scroll view
    self.popsScrollView = [[UIScrollView alloc] init];
    
    // 2 x 2
    CGFloat popsScrollViewWidth = PlaceSquareView.size.width * 2.0f;
    CGFloat popsScrollViewHeight = PlaceSquareView.size.height * 2.0f;
    self.popsScrollView.frame = CGRectMake(0.0f, 0.0f, popsScrollViewWidth, popsScrollViewHeight);
    [self.view addSubview:self.popsScrollView];
    
    // Add our initial label
    self.label = [[UILabel alloc] init];
    self.label.text = @"Tap Dash!";
    [self.label sizeToFit];
    [self.view addSubview:self.label];
    [self.label setCenter:self.popsScrollView.center];
    
    // Add our Dash button
    self.popButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.popButton addTarget:self 
                       action:@selector(pop:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.popButton setTitle:@"Dash" forState:UIControlStateNormal];
    self.popButton.frame = CGRectMake(0.0f, 480.f - 44.0f - 64.0f - 107.0f, 320.0f, 107.0f);
    [self.view addSubview:self.popButton];

    // Figure out where we are
    self.locationManager = [JCLocationManagerSingleton sharedInstance];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    // Set up the quadrantFrames
    CGFloat squareWidth = PlaceSquareView.size.width;
    CGFloat squareHeight = PlaceSquareView.size.height;
    
    CGRect firstFrame = CGRectMake(squareWidth, 0.0f, squareWidth, squareHeight);
    CGRect secondFrame = CGRectMake(0.0f, 0.0f, squareWidth, squareHeight);
    CGRect thirdFrame = CGRectMake(0.0f, squareHeight, squareWidth, squareHeight);
    CGRect fourthFrame = CGRectMake(squareWidth, squareHeight, squareWidth, squareHeight);
    
    self.quadrantFrames = [[NSMutableArray alloc] initWithObjects:
                           [NSValue valueWithCGRect:firstFrame],
                           [NSValue valueWithCGRect:secondFrame],
                           [NSValue valueWithCGRect:thirdFrame],
                           [NSValue valueWithCGRect:fourthFrame], nil];
    
    // Set up the quadrants
    self.quadrantCells = [[NSMutableArray alloc] initWithCapacity:kPlacesPerPage];
    PlaceSquareView *cell;
    NSValue *value;
    CGRect cellFrame;
    for (int i = 0; i < kPlacesPerPage; ++i) {
        value = [self.quadrantFrames objectAtIndex:i];
        cellFrame = [value CGRectValue];
        cell = [[PlaceSquareView alloc] initWithFrame:cellFrame];
        [self.quadrantCells addObject:cell];
        [self.popsScrollView addSubview:cell];       
    }
    
    // Add our progress hud
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.popsScrollView];
    [self.popsScrollView addSubview:self.progressHUD];
    self.progressHUD.delegate = self;
    self.progressHUD.removeFromSuperViewOnHide = NO;
    
    // Add our tap gesture recognizer
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.popsScrollView addGestureRecognizer:self.singleTap];
    [self.singleTap setDelegate:self];
    
    // Add our drag gesture recognizer
    self.drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [self.view addGestureRecognizer:self.drag];
    [self.drag setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Make sure we turn off location services
    // TODO: Make sure we restart it when we need it...
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"UNLOAD");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        //NSLog(@"latitude %+.6f, longitude %+.6f\n",
        //      newLocation.coordinate.latitude,
        //      newLocation.coordinate.longitude);
        [manager stopUpdatingLocation];
        [manager startMonitoringSignificantLocationChanges];
    }
    // else skip the event and process the next one.
}

#pragma mark - UIGestureRecognizer Delegate

/** Receive touch events and respond accordingly.
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    // Find out where we tapped
    CGPoint tapPoint = [gestureRecognizer locationInView:self.view];
    
    // Only care if we have places being displayed
    if (self.currentPage >= 0) {
        // Figure out which quadrant was tapped
        QuadrantIndex quadrant = -1;
        NSValue *value;
        CGRect frame;
        for (int i = 0; i < kPlacesPerPage; ++i) {
            value = [self.quadrantFrames objectAtIndex:i];
            frame = [value CGRectValue];
            if (CGRectContainsPoint(frame, tapPoint)) {
                quadrant = i;
                break;
            }
        }
        
        //NSLog(@"Quadrant %d was tapped!", quadrant);
        
        // Perform segue to place view controller
        Place *place = [self placeForQuadrant:quadrant];
        [self performSegueWithIdentifier:kShowDashViewDetailsSegueIdentifier sender:place];
    }
}

/** Perceive a drag and respond accordingly
 */
- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Reset isDragging
        self.dragging = NO;
    }
    else if (self.isDragging) {
        // Keep track of where we are
        CGPoint origin = [gestureRecognizer locationInView:self.view];
        self.filterView.center = origin;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Pan begins");
        
        // Otherwise, we want to start dragging if the gesture begins in the pop button
        //CGPoint origin = [self.view convertPoint:[gestureRecognizer locationInView:self.view] 
        //                                  toView:self.popButton];
        CGPoint origin = [gestureRecognizer locationInView:self.view];
        
        NSLog(@"origin %f %f", origin.x, origin.y);

        if (CGRectContainsPoint(self.popButton.frame, origin)) {
            NSLog(@"Started in pop button!");
            
            // Now, we are dragging
            self.dragging = YES;
            
            // Make sure we have a filter view to show
            if (self.filterView == nil) {
                CGRect filterFrame = CGRectMake(0.0f, 0.0f, 320.0f, 200.0f);
                self.filterView = [[FilterView alloc] initWithFrame:filterFrame];
                [self.filterView setBackgroundColor:[UIColor blackColor]];
                [self.view addSubview:self.filterView];
            }
        }
    }
}

#pragma mark -

- (void)pop:(id) sender
{
    // Remove initial view
    if (self.currentPage == kPrePopPage) {
        [self.label removeFromSuperview];
    }
    
    // Find out where we are
    CLLocation *loc = [self.locationManager location];
    
    // If we have enough places to show, show next page
    if ([self canShowNextPage]) {
        [self showNextPage];
    }
    else {
        // Otherwise, indicate we are now loading
        [self.progressHUD show:YES];
        
        // And send request to API for more places
        [self.api pop:loc];
    }
}

#pragma mark - Paging logic

- (Place *)placeForQuadrant:(QuadrantIndex)quadrant
{
    NSInteger firstIndex = [[self class] firstIndexForPage:self.currentPage];
    Place *place = [self.places objectAtIndex:firstIndex + quadrant];
    
    return place;
}

/** Figures out if we have enough places in our array to show the next page
 */ 
- (BOOL)canShowNextPage
{
    NSInteger maxIndexAvailable = self.places.count - 1;
    NSInteger lastPageWeCanShow = [[self class] pageForIndex:maxIndexAvailable];
    
    return (lastPageWeCanShow == self.currentPage) ? NO : YES;
}

/** Assumes that we have enough places to display. 
    Should not call if there's nothing to show.
 */
- (void)showNextPage
{
    // Should never happen
    NSAssert([self canShowNextPage], @"Tried to showNextPage when canShowNextPage fails");
    
    ++self.currentPage;
    NSInteger firstIndex = [[self class] firstIndexForPage:self.currentPage];
    NSInteger lastIndex = firstIndex + kPlacesPerPage;
    Place *place;
    PlaceSquareView *squareCell;
    NSInteger quadrant;
    
    for (int i = firstIndex; i < lastIndex; ++i) {
        quadrant = i % kPlacesPerPage;
        place = [self placeForQuadrant:quadrant];
        squareCell = [self.quadrantCells objectAtIndex:quadrant];
        [squareCell setWithPlace:place];
    }
    
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowDashViewDetailsSegueIdentifier]) {
        Place *place = (Place *)sender;
        PlaceViewController *placeViewController = (PlaceViewController *)[segue destinationViewController];
        [placeViewController setPlace:place];
        
        // Make sure it has a managed object context
        [placeViewController setManagedObjectContext:self.managedObjectContext];
    }
    else if ([[segue identifier] isEqualToString:kPresentFilterViewController]) {
        NSLog(@"Presenting filter view controller");
    }
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // We are done loading, so stop the progress hud
    [self.progressHUD hide:YES]; 
    
    // Get the objects we've just loaded and fill our places array with them
    [self.places addObjectsFromArray:objects];
    
    // Now, show them
    [self showNextPage];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    //NSLog(@"Encountered an error: %@", error);
}

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}

@end
