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
#import "PlaceSquareViewCell.h"
#import "Constants.h"
#import "PlaceViewController.h"

@implementation DashViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize locationManager = _locationManager;
@synthesize places = _places;

@synthesize loading = _loading;
@synthesize currentPage = _currentPage;

@synthesize popsScrollView = _popsScrollView;
@synthesize progressHUD = _progressHUD;
@synthesize label = _label;
@synthesize popButton = _popButton;
@synthesize singleTap = _singleTap;

@synthesize quadrants = _quadrants;
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
    self.currentPage = kPrePopPage; // -1
    self.places = [[NSMutableArray alloc] initWithCapacity:12];
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Add our pops scroll view
    self.popsScrollView = [[UIScrollView alloc] init];
    
    // 2 x 2
    CGFloat popsScrollViewWidth = PlaceSquareViewCell.size.width * 2.0f;
    CGFloat popsScrollViewHeight = PlaceSquareViewCell.size.height * 2.0f;
    self.popsScrollView.frame = CGRectMake(0.0f, 0.0f, popsScrollViewWidth, popsScrollViewHeight);
    [self.view addSubview:self.popsScrollView];
    
    // Add our initial label
    self.label = [[UILabel alloc] init];
    self.label.text = @"Tap Dash!";
    [self.label sizeToFit];
    [self.view addSubview:self.label];
    [self.label setCenter:self.popsScrollView.center];
    
    // Add our Dash button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(pop:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Dash" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0f, 480.f - 44.0f - 64.0f - 100.0f, 320.0f, 100.0f);
    [self.view addSubview:button];

    // Figure out where we are
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    // Set up the quadrantFrames
    CGFloat squareWidth = PlaceSquareViewCell.size.width;
    CGFloat squareHeight = PlaceSquareViewCell.size.height;
    
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
    self.quadrants = [[NSMutableArray alloc] initWithCapacity:kPlacesPerPage];
    PlaceSquareViewCell *cell;
    NSValue *value;
    CGRect cellFrame;
    for (int i = 0; i < kPlacesPerPage; ++i) {
        value = [self.quadrantFrames objectAtIndex:i];
        cellFrame = [value CGRectValue];
        cell = [[PlaceSquareViewCell alloc] initWithFrame:cellFrame];
        [self.quadrants addObject:cell];
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
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        [manager stopUpdatingLocation];
        [manager startMonitoringSignificantLocationChanges];
    }
    // else skip the event and process the next one.
}

#pragma mark - UIGestureRecognizer Delegate

/** Receive touch events and respond accordingly.
 */
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
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
        
        NSLog(@"Quadrant %d was tapped!", quadrant);
        
        // Perform segue to place view controller
        Place *place = [self placeForQuadrant:quadrant];
        [self performSegueWithIdentifier:kShowDashViewDetailsSegueIdentifier sender:place];
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
    NSAssert([self canShowNextPage], @"Tried to showNextPage when canShowNextPage is false");
    
    ++self.currentPage;
    NSInteger firstIndex = [[self class] firstIndexForPage:self.currentPage];
    NSInteger lastIndex = firstIndex + kPlacesPerPage;
    Place *place;
    PlaceSquareViewCell *squareCell;
    NSInteger quadrant;
    
    for (int i = firstIndex; i < lastIndex; ++i) {
        quadrant = i % kPlacesPerPage;
        place = [self.places objectAtIndex:i];
        squareCell = [self.quadrants objectAtIndex:quadrant];
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
